#!/bin/bash

home='/home/curt/'
webroot='/srv/www/htdocs/nodeStats';

server=( gfs1.carpy.net gfs2.carpy.net )

if [ ! -d $webroot ]
then
mkdir -p $webroot
fi

for i in "${server[@]}" 
do
echo 'server:' $i
scp nodeStats-html.pl $i:$home
ssh -t $i "chmod 755 nodeStats-html.pl;sudo $home/nodeStats-html.pl"
scp $i:$home/$i*.html $webroot/
done

