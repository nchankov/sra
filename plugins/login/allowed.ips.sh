#!/bin/bash

# Script for checking if provided IP as parameter exists in the file .ip

IP=$1
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

if [ ! -f $DIR/.ip ];then
    echo "0";
    exit
fi

while read p; do
  if [[ $IP == $p* ]]; then
    echo "1"
    exit
  fi
done < $DIR/.ip
echo "0"