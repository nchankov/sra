#/bin/bash

# The script could be used to generate a JSON report of system resources

# Curent directory
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

# Check if .env file exists
if [ ! -f $DIR/.env ]; then
   echo "";
   echo "Configuration .env file is missing";
   echo "";
   exit
fi

# Load environment variables
set -a
source $DIR/.env
set +a


procesor_count=`grep -c ^processor /proc/cpuinfo`

# Processors
load1=`cat /proc/loadavg | awk '{print $1}'` #Last minute
load2=`cat /proc/loadavg | awk '{print $2}'` #Last 5 minutes
load3=`cat /proc/loadavg | awk '{print $3}'` #last 15 minutes

processors="{\"max\":\"${procesor_count}\",\"load\":{\"1\": \"${load1}\",\"5\": \"${load2}\",\"15\": \"${load3}\"}}"

# Memory
mem_load1=`free -m|grep "Mem:" | awk '{print $2}'` #all memory
mem_load2=`free -m|grep "Mem:" | awk '{print $7}'` #all memory
memory="{\"total\":\"${mem_load1}\",\"free\":\"${mem_load2}\"}"

# Disks - only if they are full above the threshold
disk_message=`df -H | grep -vE '^Filesystem|tmpfs|cdrom' | awk '+$5>='$MAX_DISK_USED' { print "{\"disk\":\""$1"\",\"usage\":\""$5"\",\"size\":\""$2"\",\"available\":\""$4"\"}"}'`
disk_message=${disk_message//$'\n'/,}

echo "{\"processors\":${processors},\"memory\":${memory},\"disks\":[${disk_message}]}"