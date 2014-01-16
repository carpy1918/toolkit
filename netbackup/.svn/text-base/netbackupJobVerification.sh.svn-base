#!/bin/bash

#
#This script will verify that each policy was run and created backup files for the client servers
#
APP=/usr/openv/netbackup/bin/admincmd/bpimagelist
#runCommand takes a server list and policy and checks for backup files
function runCommand {

local array=( `echo "$1"` )
policy=$2;

for i in "${array[@]}"
do

if $APP -hoursago 168 -policy $policy -client $i &> /dev/null
then
HOLDER=1
else
#echo 'backup images NOT found for' $i " " $policy
OUTPUT="$OUTPUT \nbackup images NOT found for $i $policy "
fi

done

} #end runCommand

linuxServers=( chiabkc201-bu chiadbc201-bu chiadbc202-bu chiadnc201-bu chiadnc202-bu chiaksc201-bu chiramc201-bu chiramc202-bu chirasc201 chirasc202 chisdac201 chisdac202 chisdbc201-bu chisdbc202-bu chisdwc201-bu chisdwc202-bu chissoc201-bu chissoc202-bu chistdc201-bu chistdc202-bu chistec201-bu chistec202-bu chipwbc201 chipwbc202 chipwbc203 chipwbc204 chiawbc201 chiawbc202 chipatc201 chipdyc201-bu chipdyc202-bu )

solarisServers=( chirdbc201-bu chirdbc202-bu )

windowsServers=( chiatsc201-bu chiatsc202-bu )

portalServers=( chipwbc201 chipwbc202 chipwbc203 chipwbc204 chipatc201 chiawbc201 chiawbc202 )

itacticsServers=( chisdac201 chisdac202 chisdwc201-bu chisdwc202-bu chissoc201-bu chissoc202-bu chistdc201-bu chistdc202-bu chistec201-bu chistec202-bu )

datonaServers=( chipdyc201-bu chipdyc202-bu chisdbc201-bu chisdbc202-bu )

arcsightDBServers=( chirdbc201-bu chirdbc202-bu )

arcsightAppServers=( chiramc201-bu chiramc202-bu chirasc201 chirasc202 )

OUTPUT="NetBackup Image File Report Last Week From $(date +%m%d%Y)\n"
#linux-os-bkup
arrayPointer=`echo ${linuxServers[@]}`;
policy='linux-os-bkup';
runCommand "$arrayPointer" $policy

#solaris-os-bkup
arrayPointer=`echo ${solarisServers[@]}`;
policy='solaris-os-bkup';
runCommand "$arrayPointer" $policy

#windows-os-bkup
arrayPointer=`echo ${windowsServers[@]}`;
policy='windows-os-bkup';
runCommand "$arrayPointer" $policy

#portals
arrayPointer=`echo ${portalServers[@]}`;
policy='Portals';
runCommand "$arrayPointer" $policy

#itactics
arrayPointer=`echo ${itacticsServers[@]}`;
policy='Itactics';
runCommand "$arrayPointer" $policy

#datona
arrayPointer=`echo ${datonaServers[@]}`;
policy='Datona';
runCommand "$arrayPointer" $policy

#arcsight oracle rdbc
#arrayPointer=`echo ${arcsightDBServers[@]}`;
#policy='ArcSight-Oracle-rdbc';
#runCommand "$arrayPointer" $policy

#arcsight app
arrayPointer=`echo ${arcsightAppServers[@]}`;
policy='ArcSight-App';
runCommand "$arrayPointer" $policy

OUTPUT="$OUTPUT \n"
printf "$OUTPUT" | mail -s "NetBackup Image File Report Last Week From $(date +%m%d%Y)" cc771m@att.com -- -r "netbackup@att.com"
printf "$OUTPUT" | mail -s "NetBackup Image File Report Last Week From $(date +%m%d%Y)" fh8510@att.com -- -r "netbackup@att.com"
printf "$OUTPUT" | mail -s "NetBackup Image File Report Last Week From $(date +%m%d%Y)" rh2732@att.com -- -r "netbackup@att.com"
