#!/bin/bash 

echo "Enter regex to find containers to check by name"
read containers_regex

found_containers='/tmp/containers.txt'

docker ps -a --format='{{.Names}} {{.ID}} {{.Status}}' | awk '{print $1 " " $2 " " $3}'  > $found_containers

filter_containers='/tmp/containers.txt.filter'

cat $found_containers | grep -iE $containers_regex > $filter_containers

rm $found_containers

exit_status=0

while read -r line;
do 

	container_status="up"
	if ! [ "`echo $line | awk '{print $3}'`" = 'Up' ];
	then 
		container_status="fail"
		exit_status=1
	fi

	echo "`echo $line | awk '{print $2}'`:${container_status}"
	
	zabbix_sender --config /etc/zabbix/zabbix_agentd.conf --key="docker.container" --value="`echo $line | awk '{print $2}'`:${container_status}" > /dev/null 2>&1

done < $filter_containers

zabbix_sender --config /etc/zabbix/zabbix_agentd.conf --key="docker.container.status"   --value="${exit_status}" > /dev/null 2>&1

rm $filter_containers
