#!/bin/bash

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

#install cron.d for resources scanner
touch /etc/cron.d/sra_resources
echo "* * * * * root $DIR/sra.resources.sh" > /etc/cron.d/sra_resources
#install cron.d for locations scanner
touch /etc/cron.d/sra_locations
echo "$LOCATION_SCAN_SCHEDULE root $DIR/sra.locations.sh" > /etc/cron.d/sra_locations

#install profile script to check for logins
touch /etc/profile.d/sra.login.sh
command='if [ -n "$SSH_CLIENT" ]; then 
    '$DIR'/sra.login.sh
fi'
echo "$command" > /etc/profile.d/sra.login.sh