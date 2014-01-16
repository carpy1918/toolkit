#!/bin/sh

#
#push config file change on clients
#

. ./tealeaf-env.sh
MODCONFIG=$1
CONFIG=$2

for servers in `ls $TEALEAF_HOME/servers/`; do

pssh -h $TEALEAF_HOME/servers/$servers $TEALEAF_HOME/scripts/config-column-mon.pl ../config-templates/$MODCONFIG $CONFIG "   "

done #end for loop
