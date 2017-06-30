#!/bin/bash
echo "Enter your mysql user"
read -s YUSERNAME
echo "Enter your mysql password"
read -s YPASSWORD

echo "Enter NEW USER mysql username"
read -r USERNAME

echo "Enter NEW USER mysql password"
read -r PASSWORD

function runmysql() {
	local CMD=$1
	echo "EXEC: ${CMD}"
        mysql --user="${YUSERNAME}" --password="${YPASSWORD}" -e "$CMD"

        if [ $? -eq 0 ];
        then
                echo "OK!"
        else
                echo "Fail ON ${CMD}!"
		exit 1;
        fi
}


echo "Enter mysql database"
read -r MYSQL_DB

echo "MySQL db exists?(Y/n)"
read -r MYSQL_DB_EXISTS
if [ "${MYSQL_DB_EXISTS}" = "n" ];
then
	runmysql "CREATE DATABASE ${MYSQL_DB}"
fi;

runmysql "CREATE USER '${USERNAME}'@'localhost' IDENTIFIED BY '${PASSWORD}'"
runmysql "GRANT ALL PRIVILEGES ON ${MYSQL_DB}.* TO '${USERNAME}'@'localhost'"
runmysql "FLUSH PRIVILEGES;"
