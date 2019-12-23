#!/bin/bash

DIRECTORY=/tmp/
MYSQL_USER='backup'
MYSQL_PASS='backup'


while [[ $# -gt 1 ]]
do
key="$1"

case $key in
    -u|--user)
    MYSQL_USER="$2"
    shift # past argument
    ;;
    -p|--pass)
    MYSQL_PASS="$2"
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

DATABASES=$(mysql --user=$MYSQL_USER --password=$MYSQL_PASS -sNe "show databases;")

if [ ! $? -eq 0 ];
then
	echo "Unable to fetch all databases"
	exit 2;
fi;

if [ ! -d "${DIRECTORY}" ];
then
	echo "${DIRECTORY} does not exists!"
	exit 3
fi

TARGET_DIR=$(date +"%Y_%m_%d_%H")
TARGET_DIR="${DIRECTORY}/${TARGET_DIR}"

if [ ! -d "${TARGET_DIR}" ];
then
	mkdir "${TARGET_DIR}"
fi

for db in $DATABASES;
do

	[ $db == "mysql" ] && continue;
	[ $db == "information_schema" ] && continue;
	[ $db == "performance_schema" ] && continue;
	[ $db == "sys" ] && continue;

	echo "Export of ${TARGET_DIR}/${db}.sql"
	mysqldump --add-drop-table --user=$MYSQL_USER --password=$MYSQL_PASS $db > "${TARGET_DIR}/${db}.sql"
	if [ ! $? -eq 0 ];
	then
		echo "Export of ${TARGET_DIR}/${db}.sql FAILED!"
	fi;
done
