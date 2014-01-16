#!/bin/bash

home='/home/curt/'
webroot='/srv/www/htdocs/nodeStats';

server=( gfs1.carpy.net )

for i in "${server[@]}" 
do
echo 'server:' $i
scp rpmParse.pl $i:$home
ssh -t $i "chmod 755 rpmParse.pl;sudo $home/rpmParse.pl"
scp $i:$home/$i-rpm.html $webroot/
done


