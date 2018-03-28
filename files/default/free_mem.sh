#!/bin/sh
# Free memory available in kbs
cat /proc/meminfo |grep MemAvailable | tr -s [:space:] | cut -f 2 -d ' '
