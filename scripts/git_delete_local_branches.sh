#!/bin/bash

#Script removes all local branches that do not match
#entered regex

br='^dev$|^master$'

echo "Enter branhces"
read filt

if [ ! "$(echo $filt | xargs)" = "" ]; then
  br="${filt}"
fi

echo "Removing all local branches except $br"

for branch in $(git branch | grep -ioE '([a-z0-9\_\-]+)');
do
  if ! echo $branch | egrep $br > /dev/null;
  then
    git branch -D $branch;
  fi;
done;
