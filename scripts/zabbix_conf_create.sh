#!/bin/bash 

_zabbix_conf_file="/etc/zabbix/zabbix_agentd.conf"

if [ ! -f "${_zabbix_conf_file}" ];
then
        echo "Config file ${_zabbix_conf_file} does not exists"
        exit 1
fi

_zabbix_pid="/var/run/zabbix"
_zabbix_pid_file="${_zabbix_pid}/zabbix_agentd.pid"
_zabbix_log="/var/log/zabbix-agent/"
_zabbix_log_file="${_zabbix_log}/zabbix_agentd.log"
_zabbix_server=""
_zabbix_lport="10050"
_zabbix_lip="0.0.0.0"
_zabbix_lhostname=""
_zabbix_conf="/etc/zabbix/zabbix_agentd.conf.d/"

while [ "${_zabbix_server}" = "" ];
do
        echo "Enter server hostname:"
        read _zabbix_server
done

while [ "${_zabbix_lhostname}" = "" ];
do
        echo "Enter hostname:"
        read _zabbix_lhostname
done

[ ! -d "${_zabbix_pid}" ] && mkdir -p "${_zabbix_pid}"
[ ! -d "${_zabbix_log}" ] && mkdir -p "${_zabbix_log}"

_zabbix_conf_backup="/tmp/zabbix_conf_`date +"%Y_%m_%d_%H_%M_%S"`"

cp "${_zabbix_conf_file}" "${_zabbix_conf_backup}"

echo "Backup saved to ${_zabbix_conf_backup}"

echo "
PidFile=${_zabbix_pid_file}
LogFile=${_zabbix_log_file}
LogFileSize=0
LogRemoteCommands=1
Server=${_zabbix_server}
ListenPort=${_zabbix_lport}
ListenIP=${_zabbix_lip}
ServerActive=${_zabbix_server}
Hostname=${_zabbix_lhostname}
Include=${_zabbix_conf}
" > "${_zabbix_conf_file}"
