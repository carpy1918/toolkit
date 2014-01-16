#!/bin/bash

home='/home/curt/'
webroot='/srv/www/htdocs/nodeStats';

server=( gfs1.carpy.net )

for i in "${server[@]}" 
do
echo 'server:' $i
scp logParse.pl $i:$home
ssh -t $i "chmod 755 logParse.pl;sudo $home/logParse.pl"
scp $i:$home/$i-logs.html $webroot/
done


