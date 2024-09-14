#!/bin/bash

##################################################
#                                                #
# Server Resource Monitor                        #
#                                                #
# Script for notifying unauthorized logins       #
# @author Nik Chankov                            #
# @contact https://github.com/nchankov           #
#                                                #
##################################################

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

if [ ! -f $DIR/.env ]; then
   echo "";
   echo "Configuration .env file is missing";
   echo "";
   exit
fi


set -a
source $DIR/.env
set +a


if [ -z $NAME ]; then
   NAME=`curl -s checkip.amazonaws.com`
fi

SUBJECT="Login into $NAME"

##Loop through properties and see if there is something to report

message='';
if [ "$PAM_TYPE" != "close_session" ]; then
    message=`$DIR/who.sh`
    message+="\n"
    message+=`date`
fi

if [[ ! -z $message ]]; then
   message=${message::-2}
   for file in $DIR/channels/*
   do
      resule=$($file "$SUBJECT" "$message")
      echo $resule
   done
fi