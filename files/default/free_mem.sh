#!/bin/sh
# Free memory available in kbs
freemem=$(cat /proc/meminfo |grep MemAvailable | tr -s [:space:] | cut -f 2 -d ' ')
if [ "$freemem" != "" ]
then
 echo $freemem
 exit 0
fi
cat /proc/meminfo |grep MemFree|tr -s [:space:] | cut -f 2 -d ' '
