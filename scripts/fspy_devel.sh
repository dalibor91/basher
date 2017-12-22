#!/bin/bash

fspy_dir="${HOME}/fspy"

if [ ! -d "$fspy_dir" ];
then
    git clone https://github.com/dalibor91/fspy.git $fspy_dir
fi;


tmp_docker="/tmp/Dockerfspy"

if [ -f "$tmp_docker" ];
then
    docker exec -it dockerfspy bash
    exit 0
fi;

echo "
FROM debian:9
RUN apt-get update
RUN apt-get install -y git gcc vim

" > $tmp_docker

cd $(dirname $tmp_docker)

docker build -f $tmp_docker -t dockerfspy .

docker run -it -d -v $fspy_dir:/fspy --name dockerfspy dockerfspy

docker container start dockerfspy

docker exec -it dockerfspy bash
