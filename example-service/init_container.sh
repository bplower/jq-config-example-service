#!/usr/bin/env sh
set -e
jq -n -f /settings.json.jq > /settings.json
gunicorn --bind 0.0.0.0:80 "example_service:build_app()"
