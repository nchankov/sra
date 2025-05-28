#!/bin/bash

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
BASENAME=$(basename "$DIR")

if [ -f /etc/cron.d/sra_resources_monitor ]; then
    rm /etc/cron.d/sra_resources_monitor
    echo "Deactivated plugin: $BASENAME"
fi