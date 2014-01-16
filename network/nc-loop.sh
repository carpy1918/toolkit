#!/bin/bash


for ((i=8400;i<=8419;i+=1)); do

echo "nc -z" $1 $i
if /usr/bin/nc -w 2 -z $1 $i
then
echo $i success
else
echo $i fail!
fi

done


for ((i=8600;i<=8619;i+=1)); do

echo "nc -z" $1 $i
if /usr/bin/nc -w 2 -z $1 $i
then
echo $i success
else
echo $i fail!
fi

done


for ((i=8650;i<=8659;i+=1)); do

echo "nc -z" $1 $i
if /usr/bin/nc -w 2 -z $1 $i
then
echo $i success
else
echo $i fail!
fi

done
echo "nc -z" $1 8800
if /usr/bin/nc -w 2 -z $1 8800
then
echo $i success
else
echo $i fail!
fi
