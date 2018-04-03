#!/bin/bash 

# Prints fingerprints 
# of ssh authorized keys 
# usefull when you want to check who logged in with key

FILE="/home/`whoami`/.ssh/authorized_keys"

if [ "`whoami`" = "root" ];
then
  FILE="/root/.ssh/authorized_keys"
fi

if [ ! "$1" = "" ];
then 
  FILE="$1"
fi 

while read l; do
  [[ -n $l && ${l###} = $l ]] && ssh-keygen -l -f /dev/stdin <<<$l;
done < "$FILE"
