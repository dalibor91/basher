#!/bin/bash

docker images -q | xargs docker rmi -f
