for i in `df -t gpfs| gawk '{print $6}'` ; do echo -n $i :;lsof | grep -c $i;done
