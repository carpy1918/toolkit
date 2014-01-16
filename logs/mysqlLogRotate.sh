#!/bin/bash

#
#MySQL Log Rotation
#

SOURCE='/var/lib/mysql'
BKUP_DIR='/mnt/backups'
BKUP_TAR=mysql-logs-$(date +%d%M%Y).tar

find $SOURCE -name 'mysql-bin*' -mtime +10 -exec tar rvfp $BKUP_DIR/$BKUP_TAR {} \;
gzip $BKUP_DIR/$BKUP_TAR
mv $BKUP_DIR/$BKUP_TAR.gz $BKUP_DIR/bin.logs/
find $SOURCE -name 'mysql-bin*' -mtime +10 -exec rm -f {} \;

#Remove old log archives
find $BKUP_DIR/bin.logs/ -mtime +30 -exec rm -f {} \;

