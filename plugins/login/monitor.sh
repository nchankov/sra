#!/bin/bash

# Current directory
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

# Check if the ip is in the allowed range and if so don't bother to notify
IP=`$DIR/who.ip.sh`
is_our_ip=`$DIR/allowed.ips.sh $IP`
if [ $is_our_ip == "1" ]; then
   exit;
fi

# Get the server name
if [ -z $NAME ]; then
   NAME=`curl -s checkip.amazonaws.com`
fi

SUBJECT="Login into $NAME"

# Loop through properties and see if there is something to report

MESSAGE='';
if [ "$PAM_TYPE" != "close_session" ]; then
    MESSAGE=`$DIR/who.sh`
fi

# Don't send the message
if [[ -z $MESSAGE ]]; then
   exit 0
fi


# Send the message
$DIR/../../send.sh "$SUBJECT" "$MESSAGE"