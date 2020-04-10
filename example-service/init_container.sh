#!/usr/bin/env sh
set -e

SETTINGS_PATH=/settings.json
TEMPLATE_PATH=/settings.json.jq

# If we had multiple config files that needed to be rendered, we could do that
# here by calling jq-render several times like:
#   jq-render application.json.jq application.json
#   jq-render database.json.jq database.json
jq-render $TEMPLATE_PATH $SETTINGS_PATH

# Start the gunicorn service with an empty environment using `env -1`. This is
# an attempt to minimize damage in the event code execution is obtained through
# the service
env -i gunicorn --bind 0.0.0.0:8000 "example_service:build_app('$SETTINGS_PATH')"
