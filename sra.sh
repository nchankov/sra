#!/bin/bash

##################################################
#                                                #
# Server Resource Monitor                        #
#                                                #
# Script for monitoring server resources         #
# @author Nik Chankov                            #
# @contact https://github.com/nchankov           #
#                                                #
##################################################

#email which will be notified
MAILTO=""
subject="Alert the server experience troubles"
message=""

# max load per processor
# we are getting number of processors, so we need only the max load
# per single processor
max_load=0.8

#max used space in %
max_used=90

## Parameters to the script

for i in "$@"
do
case $i in
    -e=*|--email=*)
    MAILTO="${i#*=}"
    shift # past argument=value
    ;;
    -p=*|--processors=*)
    max_load="${i#*=}"
    shift # past argument=value
    ;;
    -s=*|--subject=*)
    subject="${i#*=}"
    shift # past argument=value
    ;;
    -u=*|--usage=*)
    max_used="${i#*=}"
    shift # past argument=value
    ;;
    -\?|-h|--help)
    echo "Usage: sra.sh [OPTION...]";
    echo "SRA - Server Resource Monitor"
    echo "Sends alerts to a given email if some of the resources of the"
    echo "machine are reaching the limits"
    echo ""
    echo "-e, --email=EMAIL             email which will be notified. If no email is specified the message will be printed on the screen."
    echo "-p, --processors=DECIMAL      decimal value where 1 represent full load. Defailt value is 0.8"
    echo "-u, --usage=NUMBER            percentage of the disk usage. where 100 is no space left. Default value is 90"
    echo "-s, --subject=STRING          subject sent to the email. Default Value is: \"Alert the server experience troubles\""
    echo "-?, -h, --help                display this help and exit"
    exit;
    shift # past argument=value
    ;;
esac
done

##
# Check server load
##

#Get number of processors
processors=`grep -c ^processor /proc/cpuinfo`
#how much percentage wise is ok the load to be

#the total load for all processors
treshold=$(echo $processors*$max_load | bc) #`expr $processors \* $max_load`

#get server loads
load1=`cat /proc/loadavg | awk '{print $1}'` #Last minute
load2=`cat /proc/loadavg | awk '{print $2}'` #Last 5 minutes
load3=`cat /proc/loadavg | awk '{print $3}'` #last 15 minutes

if echo $treshold $load3 | awk '{exit $1>$2?1:0}'
then
   message="load is high:"$load3
fi

##
# Check disk usage
##

disk_message=$(df -h | awk -v ALERT="$max_used" '
   NR == 1 {next}
   $1 == "abc:/xyz/pqr" {next}
   $1 == "tmpfs" {next}
   $1 == "/dev/cdrom" {next}
   $1 == "none" {next}
   1 {sub(/%/,"",$5)}
   $5 >= ALERT {printf "%s is almost full: %d%%\n", $1, $5}
')
if [ -n "$disk_message" ]; then
   message=$message$'\n'$disk_message
fi

##
# Send message
# Send it only if there is a warning
##

if [ -n "$message" ]; then
	#get the server IP
	ip=`curl -s checkip.amazonaws.com`
	# if the email is set, then send an email otherwise print the message
	# on the screen
	if [ ! -z $MAILTO ]; then
		echo "$message" | mail -s "$ip - $subject" $MAILTO
	else
		echo "$ip - $subject"
		echo "$message"
	fi
fi
