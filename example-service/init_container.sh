#!/usr/bin/env sh

# Set abort on error. This will cause the script to fail if the jq templating
# process fails, thus preventing the service from starting with a potentially
# invalid configuration.
set -e
SETTINGS_PATH=/settings.json

# This is a jq script that searches through a given structure for null values
# and prints a human readable error for each occurence. Causes jq to exit with
# status code 5 if there are errors
NULL_CHECK_SCRIPT='[ path(..|select(type=="null")) | "Missing value for config: .\( join(".") )\n" ] | if length > 0 then (join("") | halt_error) else empty end'

# Process the settings template file (the *.jq file), writing the result to
# the expected setting path. The content is also validated by the null check
# script described above, which can potentially return a non-zero status code.
jq --null-input --from-file /settings.json.jq | tee $SETTINGS_PATH | jq "$NULL_CHECK_SCRIPT"

# Start the gunicorn service with an empty environment. This is an attempt to
# minimize damage in the event code execution is obtained through the service
env -i gunicorn --bind 0.0.0.0:8000 "example_service:build_app('$SETTINGS_PATH')"
