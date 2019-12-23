#!/bin/bash

echo "Enter mysql username"
read -s USERNAME

echo "Enter mysql password"
read -s PASSWORD

while [ 1 ];
do

	echo "Enter command to run:"
	read -r CMD
	mysql --user="${USERNAME}" --password="${PASSWORD}" -e "$CMD"

	if [ $? -eq 0 ];
	then
		echo "OK!"
	else
		echo "Fail !"
	fi
done
