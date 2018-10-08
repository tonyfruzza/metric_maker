#!/bin/sh
memfree=$(cat /proc/meminfo |grep ^MemFree|tr -s [:space:] | cut -f 2 -d ' ')
memtotal=$(cat /proc/meminfo |grep ^MemTotal|tr -s [:space:] | cut -f 2 -d ' ')
echo 100 - $memfree / $memtotal * 100 | bc -l
