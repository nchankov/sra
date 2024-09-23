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
touch /etc/cron.d/sra.resources
echo "* * * * * root $DIR/sra.resources.sh" > /etc/cron.d/sra.resources

#install cron.d for locations scanner
touch /etc/cron.d/sra.locations
echo "$LOCATION_SCAN_SCHEDULE root $DIR/sra.locations.sh" > /etc/cron.d/sra.locations

#install profile script to check for logins
touch /etc/profile.d/sra.login.sh
command='if [ -n "$SSH_CLIENT" ]; then 
    '$DIR'/sra.login.sh
fi'
echo "$command" > /etc/profile.d/sra.login.sh