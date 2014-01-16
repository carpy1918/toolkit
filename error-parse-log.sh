#!/bin/bash

#
#grab error messages from LOG
#

. /home/curt/tealeaf-svn/scripts/tealeaf-env.sh

LOGF=$1
ARCHIVE="$HOME/log-data/error-data-$(date +%m%d%Y).log"

if [ ! -d $HOME/log-data ]; then
mkdir $HOME/log-data
fi

if [ -f $LOGF ]; then
  egrep -i '(error|warning|failed|failure|panic|cannot|corrupt|exception| fault)' $LOGF >> $ARCHIVE
else
  echo "$LOGF does not exist. Exiting. syntax: error-parse-log.sh <log_file>"
fi

cat $ARCHIVE | mail -s "log monitor `hostname`-$LOGF" $EMAIL 
