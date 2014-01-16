#!/bin/bash

#This script cleans up old log file created by NetBackup

DIR="/usr/openv/logs/"
find $DIR -name '*.log' -mtime +5 -exec rm -f {} \;

DIR="/usr/openv/netbackup/logs/"
find $DIR -name 'log.*' -mtime +5 -exec rm -f {} \;

DIR="/usr/opscenter/SYMCOpsCenterServer/logs/"
find $DIR -name '*.log' -mtime +5 -exec rm -f {} \;