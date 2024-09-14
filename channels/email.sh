#!/bin/bash

#read variables from the .env file
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
set -a
source $DIR/../.env
set +a

#dont send if email is not set
if [ -z $EMAIL ];then
    exit
fi

DEFAULTVALUE=""

TITLE="${1:-$DEFAULTVALUE}"
BODY="${2:-$DEFAULTVALUE}"

BODY=${BODY//$'\n'/"\n"}

echo "$BODY" | mail -s "$TITLE" $EMAIL