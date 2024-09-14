#!/bin/bash

#read variables from the .env file
set -a
source .env
set +a

#dont send if email is not set
if [ -z $EMAIL ];then
    exit
fi

DEFAULTVALUE=""

TITLE="${1:-$DEFAULTVALUE}"
BODY="${2:-$DEFAULTVALUE}"

echo "$BODY" | mail -s "$TITLE" $EMAIL