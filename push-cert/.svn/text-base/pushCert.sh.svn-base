#!/bin/bash

home='/home/ccarp001/'
server=( gfs1 )

for i in `cat $HOME/server-info/ldap-noaccess.log` 
do
echo 'server:' $i
./expect-it.ex $i
done
