#!/bin/bash

echo "Remove containers? y/n"
read containers

echo "Remove images y/n"
read images

if [ "$containers" = "y" ];
then
  sudo docker ps -a | awk '{ print $1 }' | grep -v 'CONTAINER' | sudo xargs docker rm -f
fi

if [ "$images" = "y" ];
then
  sudo docker images | awk '{ print $3 }' | grep -v 'REPOSITORY' | sudo xargs docker rmi -f
fi
