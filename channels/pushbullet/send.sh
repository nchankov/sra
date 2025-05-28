#!/bin/bash

# Current directory
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

# Check if .env file exists
if [ ! -f $DIR/.env ]; then
     exit
fi

# Import the .env file if it exists
set -a
source $DIR/.env
set +a

# Don't send if the $TOKEN is not set
if [ -z $TOKEN ];then
     exit
fi

# Check if curl is installed
has_command=$(command -v curl >/dev/null && echo true || echo false)
if [[ $has_command == false ]]; then
    echo "curl is not installed"
    exit 1
fi

DEFAULTVALUE=""

TITLE="${1:-$DEFAULTVALUE}"
BODY="${2:-$DEFAULTVALUE}"

BODY=${BODY//$'\n'/"\n"}

curl -s --header "Access-Token: $TOKEN" \
     --header 'Content-Type: application/json' \
     --data-binary "{\
          \"title\":\"$TITLE\",\
          \"body\":\"$BODY\",\
          \"type\":\"note\"\
     }" \
     --request POST \
     https://api.pushbullet.com/v2/pushes > /dev/null 2>&1