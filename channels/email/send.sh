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

# Don't send if $EMAIL is not set
if [ -z $EMAIL ];then
    exit
fi

# Check if mail is installed
has_command=$(command -v mail >/dev/null && echo true || echo false)
if [[ $has_command == false ]]; then
    echo "mail is not installed"
    exit 1
fi

# Default value
DEFAULTVALUE=""

TITLE="${1:-$DEFAULTVALUE}"
BODY="${2:-$DEFAULTVALUE}"

BODY=${BODY//$'\n'/"\n"}

echo "$BODY" | mail -s "$TITLE" $EMAIL