# Rendering json configs using `jq`

This project uses `jq` to render environment variables into a json config file for an example service. The idea is that `jq` is used to validate the presence of configuration values provided via env vars. The goal is to minimize the coupling between a services configuration dependencies and it's operating context. This is achieved by disallowing the service access to env vars, and providing its complete configuration through a single interface: a json file.

## Usage

The simple use cases are made available through the makefile, which provides a simple help menu for ease of use.

1. Build the base image containing `jq-render`
2. Build the service image using the base image
3. Run the service image with required environment variables

```
make build-base
make build-service
make run
```

As described before, the service image just terminates after printing the configuration file is was given, and the environment variables it sees. This is a stand in for a service that would normally recieve HTTP traffic or process an event queue.

You can also observe the failure behavior by running the `run-failing` target. The failure exmaple is missing an environment variable, and includes an environment variable with an incorrect value (a boolean that is not 'true' or 'false').

```
make run-failing
```

## Project Background

### Why is this important?

Consider each service configuration as a dependency, and each platform artifact (env var/file/cli flag/stdin) as a delivery mechanism for those configs. We want to reduce platform artifacts required to deliver config dependencies to the service. The method of consolidating delivery artifacts should ensure all config dependencies are met upon service startup.

### What does that even mean?

Suppose a service requires 5 configuration values (meaning we cannot provide default values in code). If any one of those configurations are missing, our service will fail to start or worse yet fail during runtime. We should assume worse case scenario though since humans are fallible.

Imagine the service obtains each configuration by reading an env var where ever it's needed in code. Each configuration has a 1-to-1 relationship with a discrete artifact of the platform. This is to say, if a single environment variable is missing, the cooresponding config is also missing.

If a single env var is missing, it may not be detected on service start up, and could impact service availability later while processing customer requests. Since the service starts though, it gives the false sense of security that everything is okay. It's better to fail immediately if anything is missing, well before accepting any customer requests.

This is achieved by enforcing two constraints:
1. The service reads all configuration dependencies from a single platform artifact
2. The platform artifact is prepared before service startup. Service startup is never reached if artifact preparation fails.

Lets say our service now reads its configuration from a single json file. All we have to do is construct that json file. If we consider the same situation before where an env var is missing, our process of building the json file should fail. Since the configuration artifact doesn't exist, it is impossible for the service to start with an invalid/incomplete configuration, which in turn prevents the false sense of security we described above.

In the previous section we said:

> We want to reduce platform artifacts required to deliver config dependencies to the service.

You would be excused for saying "we had a bunch of env vars before, and now this config file adds yet another artifact", but the critical distinction is that only one artifact is being consumed by the service, and that one artifact is derived from the rest.

### How is `jq` used to solve this problem?

The `jq-render` script is an extremely short but carefully crafted shell script that uses `jq`. You provide it a template file (which is just a jq script that produce a json object) that references env vars. The result of that `jq` script is then checked for any null values, failing if any are present, and otherwise writing the results to a file.

This has the effect of taking several platform artifacts (env vars) and condensing them into a single artifact that provides the entire service configuration.

The service is dockerized with an init_container script that runs the `jq-render` script before running the service command. By doing so, it is implementing the last element of our thesis: configuration errors prevent the container service from even starting. Furthermore, the service is called with the prefix `env -i`, which prevents inherritence of the env vars, further protecting against directly accessing configs via env vars.

## Project Design

This project is meant to focus on the runtime environment of a docker container, so it has two directories for building docker images (`example-base` and `example-service`) plus a couple files for environment variables for running the example service.

The environment variables are provided to the container by using the `--env-file` flag pointing to a .env file. The two provided here are self explanitory- the `example.env` is a valid set of env vars, and the `failing.env` is missing a required variable, and has a value that


## Dependencies

- docker
- make
- jq
- tee
