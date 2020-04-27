# PHP 7.4.5 LfPHP Source Compile Notes

* Generally following this guide: https://linux-for-php-documentation.readthedocs.io/en/latest/basic_usage.html#compiling-php-from-source

* Run LfPHP Source Image
```
docker pull asclinux/linuxforphp-8.2-ultimate:src
docker run --rm -it asclinux/linuxforphp-8.2-ultimate:src /bin/bash
```
* Pull PHP 7.4.5 source code
```
cd /root
wget https://www.php.net/distributions/php-7.4.5.tar.gz
tar xvfz php-7.4.5.tar.gz
```
* Missing package `libzip`:
```
cd /root
wget https://libzip.org/download/libzip-1.6.1.tar.gz
tar xvfz libzip-1.6.1.tar.gz
cd libzip-1.6.1
mkdir build
cd build
cmake ..
make
make test
make install
export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig
```
* Get ready for PHP compile
```
cd /root/php-src-PHP-7.4.5
./buildconf --force
```
* Ran revised `configure` string:
```
./configure  \
    --prefix=/usr \
    --sysconfdir=/etc \
    --localstatedir=/var \
    --datadir=/usr/share/php \
    --mandir=/usr/share/man \
    --enable-fpm \
    --with-fpm-user=apache \
    --with-fpm-group=apache \
    --with-config-file-path=/etc \
    --with-zlib \
    --enable-bcmath \
    --with-bz2 \
    --enable-calendar \
    --enable-dba=shared \
    --with-gdbm \
    --with-gmp \
    --enable-ftp \
    --with-gettext=/usr \
    --enable-mbstring \
    --enable-pcntl \
    --with-pspell \
    --with-readline \
    --with-snmp \
    --with-mysql-sock=/run/mysqld/mysqld.sock \
    --with-curl \
    --with-openssl \
    --with-openssl-dir=/usr \
    --with-mhash \
    --enable-intl \
    --with-libdir=/lib64 \
    --enable-sockets \
    --with-libxml \
    --enable-soap \
    --enable-gd \
    --with-jpeg \
    --with-freetype-dir=/usr \
    --enable-exif \
    --with-xsl \
    --with-xmlrpc \
    --with-pgsql \
    --with-pdo-mysql=/usr \
    --with-pdo-pgsql \
    --with-mysqli \
    --with-mssql \
    --with-pdo-dblib \
    --with-ldap \
    --with-ldap-sasl \
    --enable-shmop \
    --enable-sysvsem \
    --enable-sysvshm \
    --enable-sysvmsg \
    --with-tidy \
    --with-expat \
    --with-enchant \
    --with-imap=/usr/local/imap-2007f \
    --with-imap-ssl=/usr/include/openssl \
    --with-kerberos=/usr/include/krb5 \
    --with-sodium=/usr \
    --with-zip \
    --enable-opcache \
    --with-pear \
    --with-ffi
```
* Made and installed PHP:
```
make clean
make
make test
make install
```
* Save the revised Docker image:
  * Keep the container is running
  * Open a new terminal window / command prompt
  * Find the container ID:
```
docker container ls
```
  * Issue this command:
    * Substitute CONTAINER_ID for the container ID discovered above
    * Substituting USER/IMAGE_NAME for your Docker username (if you don't have one, just make one up!) and the name of the image you wish to save:
```
docker commit CONTAINER_ID USER/IMAGE_NAME
```
  * Confirm that the new image exists:
```
docker image ls
```
