#!/bin/bash

echo $1
smbclient  -N -U "viant/guest" -L $1
echo "em_result=$?"
