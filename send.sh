#!/bin/bash

# This is the current directory of this script
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

# Check if there is at least one argument
# If not, print an error message and exit
if [ -z "$1" ]; then
  echo "Error: You need to provide at least a subject"
  echo "Usage: $0 SUBJECT [MESSAGE]"
  echo "Wrap the subject and message in quotes if they contain spaces."
  echo "Example: $0 \"Alert: Server Down\" \"The server is not responding.\""
  exit 1
fi

# Subject
SUBJECT="${1}"
MESSAGE="${2:-$SUBJECT}"

# Loop through all channels in the channels directory
for file in $DIR/channels/*
do
    $file/send.sh "$SUBJECT" "$MESSAGE"
done