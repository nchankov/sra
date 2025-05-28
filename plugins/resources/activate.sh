#!/bin/bash

# Current directory
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
BASENAME=$(basename "$DIR")

# Check if the .env file exists
if [ ! -f $DIR/.env ]; then
   echo "";
   echo "$BASENAME: Configuration .env file is missing";
   echo "";
   exit
fi

# Load the environment variables from the .env file
set -a
source $DIR/.env
set +a

# Install cron.d for resources scanner
touch /etc/cron.d/sra_resources_monitor
echo "* * * * * root $DIR/monitor.sh" > /etc/cron.d/sra_resources_monitor

echo "Activated plugin: $BASENAME"