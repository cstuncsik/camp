[![Docker Stars](https://img.shields.io/docker/stars/cstuncsik/camp.svg?maxAge=2592000)](https://hub.docker.com/r/cstuncsik/camp/)
[![Docker Pulls](https://img.shields.io/docker/pulls/cstuncsik/camp.svg?maxAge=2592000)](https://hub.docker.com/r/cstuncsik/camp/)
[![](https://images.microbadger.com/badges/image/cstuncsik/camp.svg)](https://microbadger.com/images/cstuncsik/camp "Get your own image badge on microbadger.com")

CAMP
====

**C**entOS **A**pache **M**ySQL **P**HP

CentOS 6.6 [docker](https://www.docker.com) image including Apache 2.4 with SSL support, MySQL 5.6 and PHP 5.6.

### MOUNT

 - **/var/www/** for site content (e.g.: **-v /path/to/site/:/var/www/**)
 - **/etc/ssl/** for SSL cert (e.g: **-v /path/to/ssl/:/etc/ssl/crt**)
 - **/var/log/httpd/** and/or **/var/log/ssl/** for check log files (e.g.: **-v /path/to/log/:/var/log/httpd/**)

### www, apache folders

There are some files for testing, they are not part of the image, however the configs from **apache/conf/extra** are copied into the image
they will be used only if you do not provide yours

### SSL cert

The image contains a default certificate for localhost for testing purposes

If you want to use your own cert you need to mount it and edit the path in the mounted apache conf file

EXAMPLES
--------

- check if apache is working
```
docker run -it -p 80:80 cstuncsik/camp:latest
```
- serve site with volume (site root) on port 8080 (mounting to default apache htdocs folder), using httpd-default.conf 
```
docker run -it -p 8080:80 -v /home/cstuncsik/projects/camp/www:/usr/local/apache2/htdocs/site.dev cstuncsik/camp:latest
```
- serve site through SSL with volume mounted to default apache htdocs folder (e.g. for testing development), using httpd-ssl.conf 
```
docker run -it -p 443:433 -v /home/cstuncsik/projects/camp/www:/usr/local/apache2/htdocs/site.dev cstuncsik/camp:latest
```
- serve site with named virtual host through SSL with volumes (site root - in custom dir, certificates - in custom dir, apache config - paths set to custom dir)
```
docker run -it -p 80:80 -p 443:443 -h site.dev -v /home/cstuncsik/projects/camp/www:/var/www -v /home/cstuncsik/projects/camp/apache/conf/custom:/usr/local/apache2/conf/custom -v /home/cstuncsik/projects/camp/apache/cert:/etc/ssl/crt cstuncsik/camp:latest
```

**If your host machine is windows you need to set the path like this: -v //c/Users/cstuncsik/projects/camp/www:/var/www**

License
-------

The MIT License (MIT)

Copyright © 2015 Csaba Tuncsik <csaba.tuncsik@gmail.com>

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
