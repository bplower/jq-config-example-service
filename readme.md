# JQ Config Service Example

This project is a super quick proof of concept for using `jq` to render a json config file for a service within a containers init process. The idea is that `jq` serves as a mechanism for converting environment variables into a tangible, version controled file consumed by the custom service.

**Disclaimer:** I dislike using environment variables in code, but recognise their value in configuring docker containers in ECS and Kubernetes. This preference to lessen my interaction and handling of environment variables is a big motivator for this experiment.

## Setup

```
cd example-service
virtualenv -p python3 venv
source venv/bin/activate
make build
docker-compose build
cd ../
```

## Running environments

The compose file is set to default to the `env.dev` file, which sets config
values for local development. We can verify the service is getting the development
values by querying the `/health` endpoint with debug output (which is designed to
return the configuration the service is running with).

```
docker-compose up --force-recreate --detach
curl -s --header "X-Debug: true" http://localhost:8000/health | jq
```

Next we can specify the test environment file.

```
TARGET_ENV=env.test docker-compose up --force-recreate --detach
curl -s --header "X-Debug: true" http://localhost:8000/health | jq
```

And lastly, just to drive the point home, we can check with the production config

```
TARGET_ENV=env.prod docker-compose up --force-recreate --detach
curl -s --header "X-Debug: true" http://localhost:8000/health | jq
```
