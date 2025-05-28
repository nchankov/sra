#!/bin/bash

# Current directory
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

# Check if .env file exists
if [ ! -f $DIR/.env ]; then
    exit 1
fi

# Import the .env file if it exists
set -a
source $DIR/.env
set +a

# Don't send if $URL is not set
if [ -z $URL ];then
    exit 1
fi

# Check if curl is installed
has_command=$(command -v curl >/dev/null && echo true || echo false)
if [[ $has_command == false ]]; then
    echo "curl is not installed"
    exit 1
fi

DEFAULTVALUE=""

message="${1:-$DEFAULTVALUE}"

# Curl command to send the message
curl -s --location \
    --request POST \
     --form "$VARIABLE=$message" \ 
     $URL > /dev/null 2>&1