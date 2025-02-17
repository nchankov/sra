#!/bin/bash

##################################################
#                                                #
# Server Resource Monitor                        #
#                                                #
# Script for snding direct messages              #
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

SUBJECT="Message from the server"

##Loop through properties and see if there is something to report

message=$1

if [[ ! -z $message ]]; then
   for file in $DIR/channels/*
   do
      result=$($file "$SUBJECT" "$message")
   done
fi