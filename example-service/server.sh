#!/usr/bin/env sh

# This file is meant to represent some service you might start at the
# end of the init_container script. Earlier versions of this project
# contained an example python service which was started in place of
# this script.

SETTINGS_PATH=$1

# Display the settings file our service was given as a result of the jq
# rendering in the init_container script. Here we catting the contents,
# but then piping it into `jq` just to prove that it is valid json
echo "Content of settings file: $SETTINGS_PATH"
cat $SETTINGS_PATH | jq

echo ""
echo "Current environment variables:"
env
