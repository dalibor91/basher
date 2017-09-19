#!/bin/bash

CURRENT_USR=$(id -u)

if [ $CURRENT_USR -ne 0 ];
then
        echo "Please run this as root user"
        exit
fi;

SYS_USER='dalibor_sys'

CONF_FILE="${PWD}/${SYS_USER}.conf"

echo "Adding user ${SYS_USER}"
useradd -r "$SYS_USER"

if [ $? -eq 0 ];
then
        LOG_DIR="/var/log/${SYS_USER}"
        LOCK_DIR="/var/lock/${SYS_USER}"
        LIB_DIR="/var/lib/${SYS_USER}"

        echo "Creating ${LOG_DIR}"
        mkdir "${LOG_DIR}"
        if [ $? -ne 0 ]; then echo "Unable to create ${LOG_DIR}"; else echo "Done."; fi;

        echo "Creating ${LOCK_DIR}"
        mkdir "${LOCK_DIR}"
        if [ $? -ne 0 ]; then echo "Unable to create ${LOCK_DIR}"; else echo "Done."; fi;

        echo "Creating ${LIB_DIR}"
        mkdir "${LIB_DIR}"
        if [ $? -ne 0 ]; then echo "Unable to create ${LIB_DIR}"; else echo "Done."; fi;

        if [ -f "${CONF_FILE}" ];
        then
                cat "${CONF_FILE}" > "${LIB_DIR}/${SYS_USER}.conf"
                if [ $? -ne 0 ]; then echo "Unable to copy configuration"; else echo "Configuration copied..."; fi;
        fi

        chown ${SYS_USER}:${SYS_USER} -R "${LOG_DIR}"
        if [ $? -ne 0 ]; then echo "Unable to change ownership ${LOG_DIR} to ${SYS_USER}"; fi;

        chown ${SYS_USER}:${SYS_USER} -R "${LOCK_DIR}"
        if [ $? -ne 0 ]; then echo "Unable to change ownership ${LOCK_DIR} to ${SYS_USER}"; fi;

        chown ${SYS_USER}:${SYS_USER} -R "${LIB_DIR}"
        if [ $? -ne 0 ]; then echo "Unable to change ownership ${LIB_DIR} to ${SYS_USER}"; fi;

else
        echo "Unable to add user ${SYS_USER}"
fi
