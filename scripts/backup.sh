#!/bin/bash

# Script for creating zip files
# /bin/bash thisscript.sh /opt/backup home.zip /home
# will create /opt/backup/{date}/home.zip from /home dir
#

destination=$1
zip_name=$2
zip_source=$3

if ! [ -d "$destination" ];
then
  echo "$destination does not exists";
  exit 1;
fi

destination="${destination}/`date +"%F"`"
if ! [ -d "${destination}" ];
then
  mkdir -p "${destination}";
  if ! [ $? -eq 0 ]; then echo "Unable to create ${destination}"; exit 2; fi
fi

if ! [ -d "${zip_source}" ];
then
  echo "${zip_source} does not exists"
  exit 3;
fi

cmd="zip -rq ${destination}/${zip_name} ${zip_source}"
echo "Running: ${cmd}"

eval $cmd
exit $?
