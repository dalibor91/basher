#!/bin/bash 

for branch in $(git branch | grep -ioE '([a-z0-9\_\-]+)'); 
do 
  git checkout $branch
  git reset --hard origin/$branch
  git pull
done
git checkout master
