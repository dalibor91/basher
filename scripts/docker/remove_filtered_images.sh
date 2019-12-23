#!/bin/bash 

NAME="*"
if [ ! "$1" = "" ];
then
  NAME=$1
fi

TAG="*"
if [ ! "$2" = "" ];
then
  TAG=$1
fi

FILTER="reference=\"name=${NAME}:${TAG}\""

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
