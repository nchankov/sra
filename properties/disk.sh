#!/bin/bash

############################################################
#
# Script which checks the disk load
#
############################################################

#read variables from the .env file
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
set -a
source $DIR/../.env
set +a

#remove the file if it's old enough
if [ -f /tmp/sra-disk ]; then
    if test `find "/tmp/sra-disk" -mmin +$MAX_TIME_TO_REPEAT`
    then
        rm /tmp/sra-disk
    fi
fi

message=`df -H | grep -vE '^Filesystem|tmpfs|cdrom' | awk '+$5>=20 { print $5 " " $1}'`

if [ -n "$message" ]; then
    if [ ! -f /tmp/sra-disk ]; then
        echo "$message" > /tmp/sra-disk
        echo "DISKS ARE FULL:"
        echo "$message"
    fi
else
    if [ -f /tmp/sra-disk ]; then
        rm /tmp/sra-disk
    fi
fi