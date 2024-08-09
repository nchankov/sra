#/bin/bash

#processors
load1=`cat /proc/loadavg | awk '{print $1}'` #Last minute
load2=`cat /proc/loadavg | awk '{print $2}'` #Last 5 minutes
load3=`cat /proc/loadavg | awk '{print $3}'` #last 15 minutes

processors="{\"load\":{\"1\": \"${load1}\",\"5\": \"${load2}\",\"15\": \"${load3}\"}}"

#memory
mem_load1=`free -mh|grep "Mem:" | awk '{print $2}'` #all memory
mem_load2=`free -mh|grep "Mem:" | awk '{print $7}'` #all memory
memory="{\"total\":\"${mem_load1}\",\"free\":\"${mem_load2}\"}"

max_used=80

disk_message=$(df -h | awk -v ALERT="$max_used" '
   NR == 1 {next}
   $1 == "abc:/xyz/pqr" {next}
   $1 == "tmpfs" {next}
   $1 == "/dev/cdrom" {next}
   $1 == "none" {next}
   1 {sub(/%/,"",$5)}
   $5 >= ALERT {printf "%s is: %d%%\n", $1, $5}
')

disks="{\"disks\":\"${disk_message}\"}"

echo "{\"processors\":${processors},\"memory\":${memory},\"disks\":${disks}}"