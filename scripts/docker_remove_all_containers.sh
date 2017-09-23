#!/bin/bash

sudo docker ps -a | awk '{ print $1 }' | grep -v 'CONTAINER' | sudo xargs docker rm -f
