#!/bin/bash

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
BASENAME=$(basename "$DIR")

if [ -f /etc/profile.d/sra_login_monitor.sh ]; then
    rm /etc/profile.d/sra_login_monitor.sh
    echo "Deactivated plugin: $BASENAME"
fi