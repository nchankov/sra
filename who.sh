#!/bin/bash

#script to identify user and it's IP when logged in

WHO_AM_I=`who am i | awk '{print $5 " " $1}'|sed 's/.\(.*\)./\1/'`
echo $WHO_AM_I