#!/bin/bash

if [ ! -f /etc/ssl/server.key ]; then
openssl req -newkey rsa:2048 -days 365 -nodes -x509 \
-subj "/C=--/ST=State/L=City/O=Server/OU=IT/CN=localhost" \
-keyout /etc/ssl/server.key \
-out /etc/ssl/server.crt
fi

ln -s /etc/ssl/server.key /etc/pki/tls/private/server.key
ln -s /etc/ssl/server.crt /etc/pki/tls/certs/server.crt

if [[ -e /etc/ssl/ca.crt ]]; then
set -i '/SSLCertificateChainFile/s/#//' /usr/local/apache2/conf/extra/httpd-ssl.conf
ln -s /etc/ssl/ca.crt /etc/pki/tls/certs/ca.crt
fi

service mysqld start
/usr/local/apache2/bin/apachectl -DFOREGROUND
