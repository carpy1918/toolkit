#!/bin/bash

home='/home/curt/'
server=( gfs1 gfs2 )

for i in "${server[@]}" 
do
echo 'server:' $i
scp nodeStats.pl $i:$home
ssh -t $i "chmod 755 nodeStats.pl;sudo $home/nodeStats.pl"
done
