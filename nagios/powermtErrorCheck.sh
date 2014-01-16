#!/bin/bash

FLAG=0;


   if [ `/sbin/powermt display dev=all | awk '/ dead/ {print $1 " " $2 " " $3 " " $6 " " $7 " " $9}'` ]
   then
   echo "fiber path dead on" `hostname`
   echo "gc_result=1"
   fi

   for i in $(/sbin/powermt display dev=all | awk '/ alive/ {print $9}' )
    do
     if [ $i != 0 ]
     then
        echo `/sbin/powermt display dev=all`
        echo "gc_result=1"
        FLAG=1;
     fi
   done

   if [ $FLAG == 0 ]
   then
   echo "gc_result=0"
   else
   echo ''
   fi


