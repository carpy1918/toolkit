#!/bin/bash

#
#monitor/clean file > size
#

. /home/curt/tealeaf-svn/scripts/tealeaf-env.sh

DIR=$1
MAXSIZE=$2

for i in `ls $DIR`
do
  if [[ $(stat -c%s $DIR/$i) -lt $MAXSIZE ]]; then
     echo $DIR/$i is over $MAXSIZE
     if [ "$MODE" = "EXECUTE" ]; then
       echo '' > $DIR/$i
     fi
  fi
done

