#!/bin/bash

#scripts prints out number of requests 
#and ip they came from 
#example of use 
#/bin/bash count_requests.sh /var/log/apache2/access.log --watch


if [ ! -f "$1" ];
then

        echo "
Usage:
        $0 <access_log_file>
        "
        exit;
fi

READFILE=$1

if [ "$2" = "--watch" ];
then
        CMD="cat ${READFILE} | awk '{ print \$1 }' | sort | uniq -c | sort -nr -k1 -b | awk '{  printf(\"%s: %s\\n\", substr(\$2 \"                \", 0, 16), \$1) }'";
        echo "$CMD";
        watch -n 1 "${CMD}"
elif [ "$2" = "--normal" ];
then
        cat $READFILE | awk '{ print $1 }' | sort | uniq -c | awk '{  printf("%s %s\n", substr($2 "                ", 0, 16), $1) }'
else
        cat $READFILE | awk '{ print $1 }' | sort | uniq -c | awk '{  printf("%s: %s\n", substr($2 "                ", 0, 16), $1) }';
fi;
