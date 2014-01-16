#!/bin/bash

#grab updatePortal exceptions from log files for the list of servers

action=$1
server=(192.168.133.128 192.168.133.130);
dir='/root/servers';
keyword='updatePortal';

if [ -z $1 ]
then
echo "syntax: grabExceptions.sh <errors|started>"
exit
fi

if [ "$action" == "errors" ];then
  for i in "${server[@]}"
  do
    echo
    echo  $i - messages log
    tail -n 1000 $dir/$i/messages | grep $keyword | egrep -i '(exception|error|warn|fail)' | xargs echo $i:
  done
elif [ "$action" == "started" ];then
  for i in "${server[@]}"
  do
    tail -n 1000 $dir/$i/messages | grep $keyword | egrep -i '(started)' | xargs echo $i:
  done
else
  echo $action is an incorrect action. exiting.
exit
fi