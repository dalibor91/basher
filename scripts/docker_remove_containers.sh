#!/bin/bash 

FILTER="name=$1"

if [ "$1" = "" ];
then 
  echo "Sure to remove all ? Ctrl+C to abort"
  read sure
fi;

for container in $(docker ps -a --filter "${FILTER}" --format "{{.ID}}");
do 
  echo "Removing ${container}";
  docker rm -vf "${container}";
done
