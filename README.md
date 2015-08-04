CAMP
====

**C**entOS **A**pache **M**ySQL **P**HP

CentOS 6.6 [docker](https://www.docker.com) image including Apache 2.4 with SSL support, MySQL 5.6 and PHP 5.6.

###MOUNT###

 - **/var/www/** for site content (e.g.: **-v /path/to/site/:/var/www/**)
 - **/etc/ssl/** for SSL cert (e.g: **-v /path/to/ssl/:/etc/ssl/**)
 - **/var/log/httpd/** and/or **/var/log/ssl/** for check log files (e.g.: **-v /path/to/log/:/var/log/httpd/**)

###www###

If there is no mounted webroot there are some files for testing apache, mysql and php.

- apache test: index.html
- mysql connection test: mysqltest.php
- php info: phpinfo.php

###SSL cert###

If there is no mounted file the image will create a new SSL cert every time it runs with the following file names:

- server.crt: Passwordless PEM encoded certificate.
- server.key: Passwordless PEM encoded key.

If you want to use your own cert you need to mount it with the same file name.

You can also mount a cetificate chain file with the name of **ca.crt** under the ssl directory.

##EXAMPLES##

- check the image bash
```sh
docker run -it ctuncsik/camp
```
- check if apache is working
```sh
docker run -it -p 80:80 ctuncsik/camp
```
- serve a site through SSL with volumes
```sh
docker run -it -p 443:443 -v /path/to/ssl/:/etc/ssl/ -v /path/to/site/:/var/www/ ctuncsik/camp
```
