#!/bin/bash

#Script which will remove a specified location from scanning

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

if [ -z $1 ]; then
    echo "==================================================================="
    echo "Specify full path to the directory you want to remove"
    read -e -p "Enter directory: " location
else
    location=$1
fi

for file in $DIR/locations/*
do
    line=$(head -n 1 $file)
    if [[ $line == $location ]]; then
        rm $file
    fi
    if [[ $line == "$location/" ]]; then
        rm $file
    fi
done