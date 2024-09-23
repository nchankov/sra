#!/bin/bash

#Script which show locations which are set for scanning

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

echo "==================================================================="
echo " Locations:"
echo "==================================================================="

total=`find $DIR/locations/ -type f -name "*.loc" | wc -l`
if [ $total == 0 ]; then
    echo ""
    echo "No locations has been added. Add some with ./add.location.sh"
    echo ""
    exit
fi

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