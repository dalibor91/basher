#!/bin/bash 

# switching users 
# bshr -r su --args www-data 
# bshr -r su --args www-data sh
echo -e "su\n\n" | bshr -a https://raw.githubusercontent.com/dalibor91/basher/master/scripts/run_as_user.sh
sleep 1

#random string
# bshr -r randstr --args 32 
# bshr -r randstr 
echo -e "randstr\n\n" | bshr -a https://raw.githubusercontent.com/dalibor91/basher/master/scripts/random_string.sh
sleep 1

#add nginx virtual host
echo -e "nginxvh\n\n" | bshr -a https://raw.githubusercontent.com/dalibor91/basher/master/scripts/nginx_vhost.sh
sleep 1

#mysql user add
echo -e "mysqluseradd\n\n" | bshr -a https://raw.githubusercontent.com/dalibor91/basher/master/scripts/mysql_user_add.sh
sleep 1

# adds backup to zip file 
# bshr -r zipbackup --args /opt/backup home.zip /home
echo -e "zipbackup\n\n" | bshr -a https://raw.githubusercontent.com/dalibor91/basher/master/scripts/backup.sh
sleep 1
