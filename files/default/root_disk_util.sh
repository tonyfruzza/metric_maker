#!/bin/sh
df /|tr -s [:space:]|grep ^/|cut -f 5 -d ' '|tr -d %
