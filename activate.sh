#!/bin/bash

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

if [ ! -f $DIR/.env ]; then
   echo "";
   echo "Configuration .env file is missing";
   echo "";
   exit
fi

#install cron.d
touch /etc/cron.d/sra
echo "* * * * * root $DIR/sra.sh" > /dev/null 2>&1

#install profile script to check for logins
touch /etc/profile.d/sra.sh
command='if [ -n "$SSH_CLIENT" ]; then 
    '$DIR'/login-notify.sh
fi'
echo "$command" > /etc/profile.d/sra.sh
