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

# Check if there is a configuration
if [ -z $SAMPLE ];then
    exit 1
fi

DEFAULTVALUE=""

message="${1:-$DEFAULTVALUE}"

# Store the file into the log file
echo $SAMPLE >> $LOG_FILE