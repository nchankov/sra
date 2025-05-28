#!/bin/bash

# Current directory
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

# Check if .env file exists
if [ ! -f $DIR/.env ]; then
   echo "";
   echo "Configuration .env file is missing";
   echo "";
   exit
fi

# Load environment variables
set -a
source $DIR/.env
set +a

# Get the server public IP or hostname
if [ -z $NAME ]; then
   NAME=`curl -s checkip.amazonaws.com`
fi

SUBJECT="Alert the server $NAME experience troubles"

# Loop through all properties files in the properties directory
MESSAGE='';
for file in $DIR/properties/*
do
   prop=$($file)
   if [[ ! -z $prop ]]; then
      MESSAGE+=$prop"\n\n";
   fi
done

# Don't send the message if there is nothing to report
if [[ -z $MESSAGE ]]; then
   exit 0
fi

# Send the message
$DIR/../../send.sh "$SUBJECT" "$MESSAGE"