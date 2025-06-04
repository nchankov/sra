#!/bin/bash

# Current directory
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

# Check if the .env file exists in the current directory. If not don't execute the script
if [ ! -f $DIR/.env ]; then
   echo "";
   echo "SAMPLE: Configuration .env file is missing";
   echo "";
   exit
fi

# Load environment variables from the .env file
set -a
source $DIR/.env
set +a

SUBJECT="Alert the server $HOSTNAME has something to report"
MESSAGE=$SAMPLE;

# Send the message. This will be sent only if $MESSAGE is not empty
$DIR/../../send.sh "$SUBJECT" "$MESSAGE"