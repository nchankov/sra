#!/bin/bash

# Current directory of the script
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
BASENAME=$(basename "$DIR")

# Check if the .env file exists
if [ ! -f $DIR/.env ]; then
   echo "";
   echo "LOCATIONS: Configuration .env file is missing";
   echo "";
   exit
fi

# Load environment variables
set -a
source $DIR/.env
set +a

#install cron.d for locations scanner
touch /etc/cron.d/sra_locations_monitor
echo "$LOCATION_SCAN_SCHEDULE root $DIR/monitor.sh" > /etc/cron.d/sra_locations_monitor

# Report that it has been set up
echo "Activated plugin: $BASENAME"