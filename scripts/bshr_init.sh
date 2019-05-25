#!/bin/bash 

#switching users 
echo -e "su\n\n" | bshr -a https://raw.githubusercontent.com/dalibor91/basher/master/scripts/run_as_user.sh

#random string
echo -e "randstr\n\n" | bshr -a https://raw.githubusercontent.com/dalibor91/basher/master/scripts/random_string.sh

#add nginx virtual host
echo -e "nginxvh\n\n" | bshr -a https://raw.githubusercontent.com/dalibor91/basher/master/scripts/nginx_vhost.sh

#mysql user add
echo -e "mysqluseradd\n\n" | bshr -a https://raw.githubusercontent.com/dalibor91/basher/master/scripts/mysql_user_add.sh
