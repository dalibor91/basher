#!/bin/bash 

# Prints fingerprints 
# of ssh authorized keys 
# usefull when you want to check who logged in with key

FILE="~/.ssh/authorized_keys"

if [ ! "$1" = "" ];
then 
  FILE="$1"
fi 

while read l; do
  [[ -n $l && ${l###} = $l ]] && ssh-keygen -l -f /dev/stdin <<<$l;
done < "$FILE"
