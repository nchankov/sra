#!/bin/bash

############################################################
#
# Script which checks the memory usage
#
############################################################

#read variables from the .env file
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
set -a
source $DIR/../.env
set +a

#remove the file if it's old enough
if [ -f /tmp/sra-memory ]; then
    if test `find "/tmp/sra-memory" -mmin +$MAX_TIME_TO_REPEAT`
    then
        rm /tmp/sra-memory
    fi
fi

mem_load1=`free -m|grep "Mem:" | awk '{print $2}'` #all memory
mem_load2=`free -m|grep "Mem:" | awk '{print $7}'` #free memory

usage=$(echo "(1-$mem_load2/$mem_load1)*100" | bc -l)

used=`printf %.2f $(echo "$usage/1.00" | bc -l)`

if echo $MAX_MEMORY_USED $usage | awk '{exit $1>$2?1:0}'
then
    if [ ! -f /tmp/sra-memory ]; then
        message="MEMORY USED: $used%"
        echo $message > /tmp/sra-memory
        echo $message
    fi
else
    if [ -f /tmp/sra-memory ]; then
        rm /tmp/sra-memory
    fi
fi