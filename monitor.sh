#/bin/bash

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

procesor_count=`grep -c ^processor /proc/cpuinfo`

#processors
load1=`cat /proc/loadavg | awk '{print $1}'` #Last minute
load2=`cat /proc/loadavg | awk '{print $2}'` #Last 5 minutes
load3=`cat /proc/loadavg | awk '{print $3}'` #last 15 minutes

processors="{\"max\":\"${procesor_count}\",\"load\":{\"1\": \"${load1}\",\"5\": \"${load2}\",\"15\": \"${load3}\"}}"

#memory
mem_load1=`free -mh|grep "Mem:" | awk '{print $2}'` #all memory
mem_load2=`free -mh|grep "Mem:" | awk '{print $7}'` #all memory
memory="{\"total\":\"${mem_load1}\",\"free\":\"${mem_load2}\"}"

max_used=80

disk_message=`df -H | grep -vE '^Filesystem|tmpfs|cdrom' | awk '+$5>='$MAX_DISK_USED' { print "{\"disk\":\""$1"\",\"usage\":\""$5"\",\"size\":\""$2"\",\"available\":\""$4"\"}"}'`
disk_message=${disk_message//$'\n'/,}

echo "{\"processors\":${processors},\"memory\":${memory},\"disks\":[${disk_message}]}"