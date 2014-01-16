#!/bin/bash

#This script will backup key files and place them in /home/backup for pickup

hostname=`hostname`
BACKUP=/home/backup/

rm -f $BACKUP/$hostname-*.tar.bz2

cd /
tar cvfj $hostname-home-$(date +%m%d%Y).tar.bz2 /home/
mv $hostname-home-$(date +%m%d%Y).tar.bz2 $BACKUP/
tar cvfj $hostname-usr-$(date +%m%d%Y).tar.bz2 /usr/
mv $hostname-usr-$(date +%m%d%Y).tar.bz2 $BACKUP/
tar cvfj $hostname-etc-$(date +%m%d%Y).tar.bz2 /etc/
mv $hostname-etc-$(date +%m%d%Y).tar.bz2 $BACKUP/

#tar cvfj $hostname-var-$(date +%m%d%Y).tar.bz2 /var/
#mv $hostname-var-$(date +%m%d%Y).tar.bz2 $BACKUP/