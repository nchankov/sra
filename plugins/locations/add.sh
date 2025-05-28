#!/bin/bash

# Script for adding location for scanning for file changes

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

location=''

location_explanation=$'===================================================================\n'
location_explanation+=$'Add only directories which are important.\n'
location_explanation+=$'Directories with large amount files would cause the script to fail\n'
location_explanation+=$'Add full path to the location you want to be scanned\n'

#request location and ask again until the user provide valid directory
while true; do
    if [ -z $1 ]; then
        echo "$location_explanation"
        read -e -p "Enter directory: " location
    else
        if [ ! -d "$1" ]; then
            echo "$location_explanation"
            read -e -p "Enter directory: " location
        else
            location=$1
        fi
    fi
    #break the loop once there is a valid directory provided
    if [ -d "$location" ]; then
        break
    fi
done

#add trailing slash to the directory so it's always the same
if [ ${location: -1} != '/' ]; then
    location+="/"
fi

#collect the extensions
if [ -z $2 ]; then
    echo "==================================================================="
    echo "::Allowed File Extensions::"
    echo "==================================================================="
    echo "Add extensions which would be included in the search."
    echo "Use comma separated e.g. php,ini,txt. Leave empty for all files"
    read -e -p "Extensions: " extensions
else
    extensions=$2
fi

#leave only alphanumeric and comma as we expect "txt,ini,exe,pm3" types
extensions=$(echo "$extensions" | sed 's/[^a-zA-Z0-9,]//g')

if [[ $extensions == ,* ]]; then
    extensions="${extensions#,}"
fi
if [[ $extensions == *, ]]; then
    extensions="${extensions%,}"
fi

#exclude conditions
exceptions=''
while true; do
    echo "==================================================================="
    echo "::Exceptions::"
    echo "==================================================================="
    echo "One condition at a time. e.g. \".git\". Leave empty to continue. Use * as wildcard"
    echo "For example \"*.txt\" to exclude all text files or \"*/.git/*\" to exclude all git directories"
    read -e -p "Exclude conditions: " exclude
    if [ -z $exclude ]; then
        break
    fi
    exceptions+=$exclude','
done
exceptions=${exceptions:: -1}

#create file
file=$DIR/locations/$RANDOM.`date +%s`.loc
touch $file

echo $location > $file
echo $extensions >> $file
echo $exceptions >> $file

echo "==================================================================="
echo "Location \"$location\" has been added."
if [ ! -z $extensions ];then
    echo "Extensions to check are \"$extensions\""
fi
if [ ! -z $exceptions ];then
    echo "Exceptions are \"$exceptions\""
fi