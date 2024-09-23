#!/bin/bash

#read variables from the .env file
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
set -a
source $DIR/../.env
set +a

DEFAULTVALUE=""

TITLE="${1:-$DEFAULTVALUE}"
BODY="${2:-$DEFAULTVALUE}"

BODY=${BODY//$'\n'/"\n"}
#dont send if the email is not set
if [ -z $PUSHBULLET_TOKEN ];then
     exit
fi

curl -s --header "Access-Token: $PUSHBULLET_TOKEN" \
     --header 'Content-Type: application/json' \
     --data-binary "{\
          \"title\":\"$TITLE\",\
          \"body\":\"$BODY\",\
          \"type\":\"note\"\
     }" \
     --request POST \
     https://api.pushbullet.com/v2/pushes > /dev/null 2>&1