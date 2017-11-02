#!/bin/bash 

if [ "$1" = "" ];
then 
  echo "Please enter username"
  exit 1
fi

if [ ! "$2" = "" ];
then 
  sudo -H -u $1 "$2"
else 
  sudo -H -u $1 /bin/bash
fi
