FROM centos:6.6

MAINTAINER Csaba Tuncsik <csaba.tuncsik@gmail.com>

# Update packeges and install dependencies for Apache 2.4 and PHP 5.6
RUN yum -y install epel-release && \
    yum -y groupinstall 'Development Tools' && \
    yum -y update && \
    yum --setopt=tsflags=nodocs -y install \
    tar \
    wget \
    bzip2-devel \
    curl-devel \
    db4-devel \
    freetype-devel \
    gd-devel \
    gdbm-devel \
    gmp-devel \
    libicu-devel \
    libjpeg-devel \
    libmcrypt-devel \
    libpng-devel \
    libtool-ltdl-devel \
    libxml2-devel \
    libxslt-devel \
    mysql-devel \
    openssl-devel \
    pcre-devel \
    readline-devel \
    sqlite-devel \
    zlib-devel

# Install MySQL 5.6 from rpm
RUN cd /usr/src && \
    wget http://dev.mysql.com/get/mysql-community-release-el6-5.noarch.rpm && \
    yum -y localinstall mysql-community-release-el6-5.noarch.rpm && \
    yum -y install mysql-community-server

# Clean yum cache
RUN  yum clean all && rm -rf /var/cache/yum/*

# Download apache source and compile
ENV APACHE_V 2.4.16
RUN cd /usr/src && \
    wget http://archive.apache.org/dist/httpd/httpd-$APACHE_V.tar.gz -O - | tar zxvf - && \
    wget http://archive.apache.org/dist/httpd/httpd-$APACHE_V-deps.tar.gz -O - | tar zxvf - && \
    cd httpd-$APACHE_V && ./configure \
        --enable-dav \
        --enable-dav-fs \
        --enable-dav-lock \
        --enable-deflate \
        --enable-expires \
        --enable-headers \
        --enable-logio \
        --enable-mods-static=most \
        --enable-nonportable-atomics=yes \
        --enable-proxy \
        --enable-proxy-http \
        --enable-reqtimeout \
        --enable-rewrite \
        --enable-so \
        --enable-ssl \
        --enable-unique-id \
        --with-included-apr \
        --with-mpm=event \
        --with-pcre=/usr \
        --with-ssl=/usr && \
    make clean && make && make install

# Download php source and compile
ENV PHP_V 5.6.11
RUN cd /usr/src && \
    wget http://www.php.net/distributions/php-$PHP_V.tar.gz -O - | tar zxvf - && \
    cd php-$PHP_V && ./configure \
        --prefix=/usr \
        --sysconfdir=/etc \
        --localstatedir=/var \
        --datadir=/usr/share/php \
        --mandir=/usr/share/man \
        --enable-bcmath \
        --enable-calendar \
        --enable-dba=shared \
        --enable-exif \
        --enable-fpm \
        --enable-ftp \
        --enable-gd-native-ttf \
        --enable-inline-optimization \
        --enable-intl \
        --enable-mbregex \
        --enable-mbstring \
        --enable-mysqlnd \
        --enable-phar \
        --enable-posix \
        --enable-soap \
        --enable-sockets \
        --enable-sysvmsg \
        --enable-sysvsem \
        --enable-sysvshm \
        --enable-wddx \
        --enable-zip \
        --with-apxs2=/usr/local/apache2/bin/apxs \
        --with-bz2=/usr \
        --with-config-file-path=/etc \
        --with-curl \
        --with-gd \
        --with-gdbm \
        --with-gettext \
        --with-gmp \
        --with-fpm-user=apache \
        --with-fpm-group=www \
        --with-freetype-dir=/usr \
        --with-iconv \
        --with-jpeg-dir=/usr \
        --with-kerberos \
        --with-libdir=lib64 \
        --with-mcrypt \
        --with-mysql=mysqlnd \
        --with-mysqli=mysqlnd \
        --with-mysql-sock=/var/run/mysqld/mysqld.sock \
        --with-openssl \
        --with-pcre-regex=/usr \
        --with-pdo-mysql=mysqlnd \
        --with-pdo-sqlite=/usr \
        --with-pear \
        --with-png-dir=/usr \
        --with-readline \
        --with-regex=php \
        --with-sqlite3=/usr \
        --with-xsl \
        --with-zlib \
        --with-zlib-dir=/usr && \
    make clean && make && make install && \
    install -v -m644 php.ini-production /etc/php.ini && \
    mv -v /etc/php-fpm.conf{.default,} && \
    install -v -m755 -d /usr/share/doc/php-$PHP_V && \
    install -v -m644 CODING_STANDARDS EXTENSIONS INSTALL NEWS README* UPGRADING* php.gif /usr/share/doc/php-$PHP_V && \
    ln -v -sfn /usr/lib/php/doc/Archive_Tar/docs/Archive_Tar.txt /usr/share/doc/php-$PHP_V && \
    ln -v -sfn /usr/lib/php/doc/Structures_Graph/docs /usr/share/doc/php-$PHP_V

# Remove sources
RUN cd /usr/src && rm -rf mysql* httpd* php*

# Generate self signed cert for localhost for development purposes
RUN cd /usr/local/apache2/conf && \
    openssl req -newkey rsa:2048 -days 365 -nodes -x509 \
    -subj "/C=--/ST=State/L=City/O=Server/OU=IT/CN=localhost" \
    -keyout server.key \
    -out server.crt

# Copy apache extra confs but enabling SSL only if it is needed (in entrypoint)
COPY apache/conf/extra/* /usr/local/apache2/conf/extra/

# Modify apache default httpd conf to load default extra conf
RUN sed -i -e '/httpd-default.conf/s/#//' /usr/local/apache2/conf/httpd.conf

# Set apache user and custom folders for mounting
RUN groupadd www && \
    useradd -G www -r apache && \
    chown -R apache:www /usr/local/apache2 && \
    mkdir -p /var/{www,log/{httpd,ssl}} && \
    chown -R apache:www /var/www && \
    chmod -R 775 /var/www

COPY bin/entrypoint.sh /
RUN chmod +x /entrypoint.sh
CMD ./entrypoint.sh

EXPOSE 80 443
