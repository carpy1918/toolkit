#!/bin/bash

declare -i LOOP=3
declare -i COUNT=0
declare -i SUCCESS=0
COMMAND="ls bea"

while [ $COUNT -lt $LOOP ]
do

 if [ $SUCCESS -eq 0 ]
  then
   echo attempting sync...
   if $COMMAND
   then
   SUCCESS=$SUCCESS+1
   echo successful command value. success value: $SUCCESS
   COUNT=$COUNT+1
   else
   echo failed attempt with error: $?. sleeping 2 seconds and then trying again...
   COUNT=$COUNT+1
   sleep 2
     if [ $COUNT -eq 3 ]
     then
     echo Failed 3 times...emailing admin group...
     echo Command failed on `hostname` with error $? | mail curtis.carpenter@viant.com
     fi #end COUNT if
   fi #end COMMAND if
 else
 COUNT=$COUNT+1
 fi #end SUCCESS if
done
