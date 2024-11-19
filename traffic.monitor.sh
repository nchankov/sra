#!/bin/bash

###
# Script to monitor traffic through network interface
# example is ./traffic.sh eth0
##
interval=2
mif=$1

ifconfig | grep $mif 2>/dev/null
if [ $? -ne 0 ] ; then
  echo "interface $mif not found"
  echo "usage: ./monitor_if <interface>"
  echo "e.g.: ./monitor_if bond2"
  exit
fi

pf="" # prefix
declare -i rpf=0 #prefix rate
frpf=0.0 #prefix rate float


function conf_pre {
   pf=""
   rpf=$1
   frpf=$1
   if [ $rpf -ge 1000 ] ; then
      frpf=$(echo "scale=2 ; $frpf/1000.0" | bc)
      rpf=$(( $rpf/1000 ))
      pf="K"
   fi
   if [ $rpf -ge 1000 ] ; then
      frpf=$(echo "scale=2 ; $frpf/1000.0" | bc)
      pf="M"
   fi
}


while true; do

   rx1=`ifconfig $mif | awk  '/RX.*bytes/ {print $5}'`
   tx1=`ifconfig $mif | awk  '/TX.*bytes/ {print $5}'`
   sleep $interval
   rx2=`ifconfig $mif | awk  '/RX.*bytes/ {print $5}'`
   tx2=`ifconfig $mif | awk  '/TX.*bytes/ {print $5}'`

   clear
   rx=$(( (($rx2-$rx1)/$interval)* 8 ))
   tx=$(( (($tx2-$tx1)/$interval)* 8 ))

   date
   echo -n "traffic RX : "
   conf_pre $rx
   echo "${frpf}${pf}bps"
   echo -n "traffic TX : "
   conf_pre $tx
   echo "${frpf}${pf}bps"
done
