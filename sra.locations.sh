#!/bin/bash

# Script which will scan the directories 
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

#no locations to scan, so exit
total=`find $DIR/locations/ -type f -name "*.loc" | wc -l`
if [ $total == 0 ]; then
    exit
fi

#start of the report
report=$(date '+%Y-%m-%d %H:%M:%S')$'\n\n'
total_changed_files=0
for file in $DIR/locations/*.loc
do
    if [ ! -f $file ]; then
        continue
    fi
    #scanning location (a directory)
    location=$(head -n 1 $file)
    #allowed extensions
    extensions=`head -2 $file | tail -1`
    #exceptions which would be ignored
    exceptions=`head -3 $file | tail -1`

    #the command
    find_command="find $location -type f "
    
    #extensions which would be searched
    if [ ! -z $extensions ]; then
        IFS=',' read -r -a ext_array <<< "$extensions"
        find_command+=" \( "
        for ext in "${ext_array[@]}"; do
            find_command+=" -name '*.$(echo "$ext" | xargs)' -o"
        done
        #remove the last -o
        find_command="${find_command% -o}"
        find_command+=" \) "
    fi

    #exceptions part of the command
    if [ ! -z $extensions ]; then
        IFS=',' read -r -a exp_array <<< "$exceptions"
        for exp in "${exp_array[@]}"; do
            find_command+=" ! -path '$exp'"
        done
    fi

    #Set how long back it would look for changes
    find_command+=" -mmin $LOCATION_INTERVAL"
    #use full file list
    find_command+="  -exec ls -lt {} +"

    #execute the command
    changed_files=`eval $find_command`
    #get the lines
    line_count=$(echo "$changed_files" | wc -l)
    
    #add location results to the report if there are lines and characters in the result
    if [ $line_count -gt 0 ] && [ ${#changed_files} -gt 0 ]; then
        total_changed_files=$((total_changed_files + line_count))
        report+="$location"
        report+=$'\n=======================================================\n'
        report+='changed files: '$line_count$'\n'
        report+=$'=======================================================\n'
        report+="$changed_files"
        report+=$'\n'
    fi
done

#notify if there are some results
if [ $total_changed_files -gt 0 ] && [ $NOTIFY_LOCATION_SCAN == 1 ];then
    SUBJECT="Alert the server $NAME have changed files in the last $LOCATION_INTERVAL minutes"
    message="Please check the /var/log/sra/sra_$(date '+%Y%m%d') file for the list of changed files"
    #create directory if it doesn't exists
    if [ ! -d "/var/log/sra" ]; then
        mkdir "/var/log/sra"
    fi
    #print the contents into the file
    echo "$report" >> /var/log/sra/sra_$(date '+%Y%m%d')

    if [[ ! -z $message ]]; then
        for file in $DIR/channels/*
        do
            result=$($file "$SUBJECT" "$message")
        done
    fi
fi