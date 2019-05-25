#!/bin/bash

echo "Enter domain"
read domain

echo "Enter root dir"
read root_dir

echo "Enter index (default: index.[html|php])"
read index_page

if [ "${index_page}" = "" ];
then
    index_page="index.html index.php"
fi

conf_file="/etc/nginx/sites-available/${domain}"
link_file="/etc/nginx/sites-enabled/${domain}"

echo "server {
  listen 80;
  listen [::]:80 ipv6only=on;

  root ${root_dir};
  index ${index_page};

  server_name ${domain} www.${domain};
  client_max_body_size 24m;

  location ~ \.php$ {
    fastcgi_split_path_info ^(.+\.php)(/.+)$;
    include fastcgi_params;
    fastcgi_param PATH_INFO $fastcgi_path_info;
    fastcgi_index index.php;
    fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
    fastcgi_pass 127.0.0.1:9000;
  }

  location / {
    try_files \$uri \$uri/ /index.php?\$query_string;
  }

  access_log /var/log/nginx/${domain}_access.log;
  error_log /var/log/nginx/${domain}_error.log;
}" > $conf_file

ln -s $conf_file $link_file

exit $?
