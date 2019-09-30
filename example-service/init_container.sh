#!/usr/bin/env sh
set -e
SETTINGS_PATH=/settings.json
jq --null-input --from-file /settings.json.jq > $SETTINGS_PATH
[ $(grep -c 'null' /settings.json) == 0 ]
env -i gunicorn --bind 0.0.0.0:80 "example_service:build_app('$SETTINGS_PATH')"
