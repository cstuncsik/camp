#!/bin/bash

if [[ -e /usr/local/apache2/conf/custom ]]; then
echo "Include conf/custom/*.conf" >> /usr/local/apache2/conf/httpd.conf
else
sed -i -e '/httpd-ssl.conf/s/#//' /usr/local/apache2/conf/httpd.conf
fi

service mysqld start
/usr/local/apache2/bin/apachectl -DFOREGROUND
