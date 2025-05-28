#!/bin/bash

# Current directory
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

# First parameter is the plugin name
PLUGIN=$1
if [ ! -z "$PLUGIN" ]; then
    if [ -f $DIR/plugins/$PLUGIN/activate.sh ]; then
        $DIR/plugins/$PLUGIN/activate.sh
    else
        echo "There is no such plugin - $PLUGIN"
        exit 1
    fi
else
    # Check if plugins directory exists
    if [ ! -d $DIR/plugins ]; then
        echo "No plugins directory found."
        exit 1
    fi
    # Deactivate all plugins
    for plugin in $DIR/plugins/*
    do
        basename=$(basename "$plugin")
        $plugin/activate.sh
    done
fi