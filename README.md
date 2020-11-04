# PHP 8.0 LfPHP Source Compile Notes

* Generally following this guide: https://linux-for-php-documentation.readthedocs.io/en/latest/basic_usage.html#compiling-php-from-source

* To build the image:
```
docker build -t USER/IMAGE:TAG .
```
* To run the image with a terminal window in background mode (e.g. when you exit the shell it continues running)
```
docker run -dit USER/IMAGE:TAG /bin/bash
```

## Dockerfile
```
#
# Builds Custom PHP from Source
#

FROM asclinux/linuxforphp-8.2-ultimate:src

COPY ./init.sh /tmp/init.sh
RUN chmod +x /tmp/init.sh
RUN /tmp/init.sh
```

## Init Script
```
#!/bin/bash
echo "Pulling PHP 8.0 source code ..."
cd /root
wget https://github.com/php/php-src/archive/PHP-8.0.zip
unzip PHP-8.0.zip

echo "Getting ready for PHP compile ..."
cd php-src-PHP-8.0
./buildconf --force

echo "Run revised configure string ..."
./configure  \
    --prefix=/usr --sysconfdir=/etc --localstatedir=/var --datadir=/usr/share/php --mandir=/usr/share/man \
    --enable-fpm --with-fpm-user=apache --with-fpm-group=apache --with-config-file-path=/etc --with-zlib \
    --enable-bcmath --with-bz2 --enable-calendar --enable-dba=shared --with-gdbm --with-gmp --enable-ftp \
    --with-gettext=/usr --enable-mbstring --enable-pcntl --with-pspell --with-readline --with-snmp \
    --with-mysql-sock=/run/mysqld/mysqld.sock --with-curl --with-openssl --with-openssl-dir=/usr \
    --with-mhash --enable-intl --with-libdir=/lib64 --enable-sockets --with-libxml --enable-soap \
    --enable-gd --with-jpeg --with-freetype --enable-exif --with-xsl --with-ldap --with-ldap-sasl \
    --with-pdo-mysql=/usr --with-pdo-pgsql --with-mysqli --with-pdo-dblib --with-pgsql \
    --enable-shmop --enable-sysvsem --enable-sysvshm --enable-sysvmsg --with-tidy --with-expat --with-enchant \
    --with-imap=/usr/local/imap-2007f --with-imap-ssl=/usr/include/openssl --with-kerberos=/usr/include/krb5 \
    --with-sodium=/usr --with-zip --enable-opcache --with-pear --with-ffi

echo "Making and installing PHP ..."
make
make test
make install
```
