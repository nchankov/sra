#!/bin/bash

# Script which will remove a specified location from scanning

# Current directory
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

# Check if the first parameter is provided
if [ -z $1 ]; then
    echo "==================================================================="
    echo "Specify full path to the directory you want to remove"
    read -e -p "Enter directory: " location
else
    location=$1
fi

# Check if the location is empty
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