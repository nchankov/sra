#!/bin/bash

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
BASENAME=$(basename "$DIR")


#install profile script to check for logins
touch /etc/profile.d/sra_login_monitor.sh
command='if [ -n "$SSH_CLIENT" ]; then 
    '$DIR'/monitor.sh
fi'
echo "$command" > /etc/profile.d/sra_login_monitor.sh

echo "Activated plugin: $BASENAME"