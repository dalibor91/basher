#!/bin/bash

LENGTH=16
if [ "$1" != "" ];
then
	LENGTH=$1
fi

LC_CTYPE=C 
LANG=C

cat /dev/urandom | tr -dc 'a-zA-Z0-9!@#$%^&*()' | fold -w $LENGTH | head -n 1
