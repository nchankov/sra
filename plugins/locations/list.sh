#!/bin/bash

#Script which show locations which are set for scanning

# Current directory
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

echo "==================================================================="
echo " Locations:"
echo "==================================================================="

# Check if there are any locations
total=`find $DIR/locations/ -type f -name "*.loc" | wc -l`
if [ $total == 0 ]; then
    echo ""
    echo "No locations has been added. Add some with ./add.sh"
    echo ""
    exit
fi

# Loop through all locations and print them
echo "List of locations to be scanned:"
echo "-------------------------------------------------------------------"
echo ""
for file in $DIR/locations/*.loc
do
    location=$(head -n 1 $file)
    if [ ! -z $location ]; then
        extensions=`head -2 $file | tail -1`
        exceptions=`head -3 $file | tail -1`
        
        record=$location
        
        if [ ! -z $extensions ]; then
            record+=" ($extensions)"
        else
            record+=" (all files)"
        fi
        if [ ! -z $exceptions ]; then
            record+=" excluding ($exceptions)"
        fi
        echo $record
    fi
done