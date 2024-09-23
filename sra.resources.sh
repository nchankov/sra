#!/bin/bash

##################################################
#                                                #
# Server Resource Monitor                        #
#                                                #
# Script for monitoring server resources         #
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

SUBJECT="Alert the server $NAME experience troubles"

##Loop through properties and see if there is something to report

message='';
for file in $DIR/properties/*
do
   prop=$($file)
   if [[ ! -z $prop ]]; then
      message+=$prop"\n\n";
   fi
done

if [[ ! -z $message ]]; then
   message=${message::-2}
   for file in $DIR/channels/*
   do
      result=$($file "$SUBJECT" "$message")
   done
fi