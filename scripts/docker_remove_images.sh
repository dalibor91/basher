#!/bin/bash 

FILTER="reference=\"name=$1:$2\""

if [ "$1" = "" ];
then 
  echo "Sure to remove all ? Ctrl+C to abort"
  read sure
fi;

for container in $(docker images --filter "${FILTER}" --format "{{.ID}}");
do 
  echo "Removing ${container}";
  docker rmi -f "${container}";
done
