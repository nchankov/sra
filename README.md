# Server Resource Alert Script (SRA)

This script is created to monitor the server resource and various metrics on the server. The script is designed to use 
plugins to extend its functionality.

The script has 2 main parts:
1. plugins - these are the scripts which will be executed periodically to monitor the server. Once there is something to
   report, the plugin will use the channels to report the data whenever it's needed.
2. channels - these are the scripts which will be used to report the event.

Channels and Plugins can be added into the script easily in case your needs doesn't match the existing ones.

## Plugin api

Each plugin should reside in the `plugins` directory and should have the following structure:

1. activate.sh - this script will be executed when the plugin is activated. Activation usually means some script would 
   be added as a cron job and it would check the server periodically.
2. deactivate.sh - this script will be executed when the plugin is deactivated. Deactivation usually means the cron job
   would be removed and the plugin will not be executed anymore.
3. monitor.sh - this is the script which will be executed periodically by the cron job.

N.B. Make sure all those scripts are executable, otherwise the plugin will not work properly.

There is a `sample` plugin in the `plugins` directory which you can use as a reference for creating your own plugins.

## Channel api
Each channel should reside in the `channels` directory and should have at least a `send.sh` script which will be 
executed once a plugin has something to report.

1. send.sh - this script will be executed by the plugin when it has something to report. The script should accept one or 
two parameters which is the message to be sent.

N.B. Make sure the script is executable, otherwise the channel will not work properly.

There is a sample channel in the `channels` directory which you can use as a reference for creating your own channels.

## Built in plugins
This script comes with 3 built-in plugins which can be used out of the box.

- **resources**   - monitors the server resources such as CPU, memory and disk usage
- **login**       - monitors the logins on the server
- **locations**   - monitors specific locations on the server for changes in the files

## Built in channels
This script comes with 3 built-in channels which can be used out of the box.

- **email** - sends the report via email
- **pushbullet** - sends the report via pushbullet
- **curl** - sends the report to a specified URL

## Requirements

Make sure you have the following packages installed on your server:

```
apt install curl
apt install bc
apt install awk
```


## Instalation:

1. clone the repository on the server which you would like to monitor

```
git clone https://github.com/nchankov/sra.git
```
Usually install it in /usr/local/lib/ directory for consystency although 
it would work from any location

1. Run the activate.sh script from the root sra directory and follow the instructions (in case of the plugins are not 
   configured)
   ```
   ./activate.sh
   ```

   Or use a spacific pligin name to activate that plugin only
   ```
   ./activate.sh [plugin_name]
   ```

2. If you want to stop all the plugins use:

   ```
   ./deactivate.sh
   ```

   Or if you want to stop a specific plugin use:

   ```
   ./deactivate.sh [plugin_name]
   ```

3. Make sure channels are activated (have .env in them), so it will send the reports.

In case you need to learn more about the built-in plugins and channels, please check the `README.md` files in the 
corresponding directories.