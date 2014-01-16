#!/bin/bash

PART=$1

. /home/curt/tealeaf-svn/scripts/tealeaf-env.sh

if [ "$PART" = "" ]; then
logger "clean-partition.sh - no partition given"
exit
fi

logger "$PART needs cleanup - looking for .log.gz and gzip'ing .log"
find $PART -name "*.log.gz" -mtime +7 -exec rm -f {} \;
find $PART -name "*.log" -mtime +4 -exec gzip {} \;

logger "$PART Partition Status:"
df -k | grep $PART$

if [ "$UNAME" = "Linux" || "UNAME" = "Debian"]; then
P=`df -k | grep $PART$ | awk '{print $4}'`
PERCENT="${P%?}"
elif [ "$UNAME" = "HP-UX" ]; then
PERCENT=`df -ks /var/ | grep % | awk '{print $1}'`
else
P=`df -k | grep $PART$ | awk '{print $4}'`
PERCENT="${P%?}"
fi
if [[ $PERCENT -gt 90 ]]; then
logger "$PART still not clean. Going deeper - search for log/ dirs."
#find $PART -name "*.rpm" -exec rm -f {} \;
#find $PART -name "*.pkg" -exec rm -f {} \;
#find $PART -name "*.zip" -exec rm -f {} \;
LOGDIR=`find $PART -type d -name "log"`
for i in $LOGDIR;
do
find $i -name "*.log*" -mtime +4 -exec gzip {} \;
done
fi

logger "$PART clean complete with:"
df -k | grep $PART$

