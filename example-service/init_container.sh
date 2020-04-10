#!/usr/bin/env sh

# Script setup
# Set abort on error. This will cause the script to fail if the jq templating
# process fails, thus preventing the service from starting with a potentially
# invalid configuration.
set -e
SETTINGS_PATH=/settings.json

# Template the environment variables into the settings template file, writing
# the resulting data to the expected settings filepath
jq --null-input --from-file /settings.json.jq > $SETTINGS_PATH

# Environment variables required by the template that were not test will
# result in unquoted strings of "null". In this case, we don't want any
# null values in our configuration (this may be different in your case)
# so we grep for null. If no items were found, the exit code will be 0. If
# instances of 'null' are found, the exit code will not be 0, and the
# comparison will be false, thus causing the script to early abort because
# of the `set -e`.
[ $(grep -c 'null' $SETTINGS_PATH) == 0 ]

# Start the gunicorn service with an empty environment. This is an attempt to
# minimize damage in the event code execution is obtained through the service
env -i gunicorn --bind 0.0.0.0:8000 "example_service:build_app('$SETTINGS_PATH')"
