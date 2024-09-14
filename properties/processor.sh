#!/bin/bash

############################################################
#
# Script which checks the processors' load
#
############################################################

#read variables from the .env file
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
set -a
source $DIR/.env
set +a

#remove the file if it's old enough
if [ -f /tmp/sra-processor ]; then
    if test `find "/tmp/sra-processor" -mmin +$MAX_TIME_TO_REPEAT`
    then
        rm /tmp/sra-processor
    fi
fi

#Get number of processors
processors=`grep -c ^processor /proc/cpuinfo`
#how much percentage wise is ok the load to be

#the total load for all processors
treshold=$(echo $processors*$MAX_PROCESSOR_LOAD/100 | bc)

#get server loads
load1=`cat /proc/loadavg | awk '{print $1}'` #Last minute
load2=`cat /proc/loadavg | awk '{print $2}'` #Last 5 minutes
load3=`cat /proc/loadavg | awk '{print $3}'` #last 15 minutes

if echo $treshold $load3 | awk '{exit $1>$2?1:0}'
then
    if [ ! -f /tmp/sra-processor ]; then
        message="LOAD IS HIGH: $load3"
        echo $message > /tmp/sra-processor
        echo $message
    fi
else
    if [ -f /tmp/sra-processor ]; then
        rm /tmp/sra-processor
    fi
fi