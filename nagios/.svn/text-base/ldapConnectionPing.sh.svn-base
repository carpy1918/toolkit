#!/bin/bash

echo $1
/usr/bin/ldapsearch -h $1 -x -b 'ou=People,dc=corp,dc=viant,dc=net' '(uid=curtis.carpenter)'
echo "em_result=$?"
