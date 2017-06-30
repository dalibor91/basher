#!/bin/bash


mpm_itk=$(apache2ctl -M | grep mpm_itk_module)
cur_date=$(date +"%Y_%m_%d")


if [ "${mpm_itk}" = "" ];
then
	echo "please install mpm_itk_module";
	echo "apt-get install libapache2-mpm-itk"
	exit 1;
fi;

echo -e "Enter user to run virtual host as:"
read -r RUN_AS_USER

echo -e "Enter group to run virtual host as:"
read -r RUN_AS_GROUP

echo -e "Enter host name"
read -r HOST_DOMAIN

echo -e "Is app in /var/www dir (Y/n)"
read -r IS_IN_WWW

if [ "${IS_IN_WWW}" = "n" ];
then
	echo "Link aplication directory"
	read -r APP_DIR
	echo "creatig simbolic lync /var/www/${HOST_DOMAIN}"
	ln -s "${APP_DIR}" "/var/www/${HOST_DOMAIN}"
fi;

PUBLIC_DIR="/var/www/${HOST_DOMAIN}"
echo "Is document root: '${PUBLIC_DIR}' (Y/n)"
read -r IS_P_W
if [ "${IS_P_W}" = "n" ];
then
	echo -e "Enter public dir of app"
	read -r PUBLIC_DIR
fi


SITE_AVAIL="/etc/apache2/sites-available/${HOST_DOMAIN}_${cur_date}.conf"
SITE_ENABL="/etc/apache2/sites-enabled/${HOST_DOMAIN}_${cur_date}.conf"

echo -e "
<VirtualHost *:80>
        ServerName www.${HOST_DOMAIN}
        ServerAlias ${HOST_DOMAIN}

        ServerAdmin webmaster@localhost
        DocumentRoot ${PUBLIC_DIR}

        <IfModule mpm_itk_module>
                AssignUserID ${RUN_AS_USER} ${RUN_AS_GROUP}
        </IfModule>

        <Directory ${PUBLIC_DIR}>
           AllowOverride All
           Options +Includes -Indexes
        </Directory>

        <Files \"error_log\">
          Order allow,deny
          Deny from all
        </Files>

        ErrorLog \${APACHE_LOG_DIR}/${HOST_DOMAIN}/error.log
        CustomLog \${APACHE_LOG_DIR}/${HOST_DOMAIN}/access.log combined

</VirtualHost>
" > "${SITE_AVAIL}";

mkdir "/var/log/apache2/${HOST_DOMAIN}"

ln -s "${SITE_AVAIL}" "${SITE_ENABL}"

service apache2 reload


echo "${HOST_DOMAIN} is set up!"
