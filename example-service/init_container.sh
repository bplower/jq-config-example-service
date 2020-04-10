#!/usr/bin/env sh

# Set abort on error. This will cause the script to fail if the jq templating
# process fails, thus preventing the service from starting with a potentially
# invalid configuration.
set -e
SETTINGS_PATH=/settings.json

# This is a jq script. It searches through a given structure for any null
# values. It builds the key path (like ".my.foo.bar") and prints a human
# readable warning for each occurence. Finally, it asserts that the list of
# nulls should be zero in length. This will report 'false' when there are
# errors, which causes jq to exit with a non-zero exit code when run with the
# '--exit-status' flag
NULL_CHECK_SCRIPT='[ path(..|select(type=="null")) | join(".") ] | (.[] | "Missing value for config: .\(.)"), length == 0'

# Process the settings template file (the *.jq file), writing the result to
# the expected setting path. The resulting content is also piped into a
# validation script, which checks for null values, returning a non-zero exit
# code if any are found.
jq --null-input --from-file /settings.json.jq | tee $SETTINGS_PATH | jq --exit-status --raw-output "$NULL_CHECK_SCRIPT"

# Start the gunicorn service with an empty environment. This is an attempt to
# minimize damage in the event code execution is obtained through the service
env -i gunicorn --bind 0.0.0.0:8000 "example_service:build_app('$SETTINGS_PATH')"
