#!/bin/bash

DIRECTORY=/tmp/
TARGET="/home"

while [[ $# -gt 1 ]]
do
key="$1"

case $key in
    -t|--target)
    TARGET="$2"
    shift # past argument
    ;;
    -d|--dir)
    DIRECTORY="$2"
    shift # past argument
    ;;
    *)
        echo "Unknown option $1";
        exit 1;
    ;;
esac
        shift # past argument or value
done

chosen='';

for dir in $(echo $TARGET | sed s/,/\\n/g);
do
	if [ -d "$dir" ];
	then
		echo "backuping ${dir}"
		chosen="$chosen ${dir}"
	else
		echo "$dir is not directorium"
	fi
done

if [ "$chosen" == "" ];
then
	echo "Nothing to zip"
	exit 1
fi


zip_installed=$(which zip)
if [ "$zip_installed" == "" ];
then
	echo "Please install zip"
	exit 2
fi;


installloc=$(date +"%Y_%m_%d_%H_%M_%S")
installloc="${DIRECTORY}/${installloc}.zip"

echo "zip -rq ${installloc}${chosen}"

zip -rq $installloc $chosen
