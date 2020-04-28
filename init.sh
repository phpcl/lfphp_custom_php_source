#!/bin/bash

echo "Handling missing package libzip ..."
wget https://libzip.org/download/libzip-1.6.1.tar.gz
tar xvfz libzip-1.6.1.tar.gz
cd libzip-1.6.1
mkdir build
cd build
cmake ..
make
make install
export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig

echo "Pulling PHP 7.4.5 source code ..."
cd /root
wget https://www.php.net/distributions/php-7.4.5.tar.gz
tar xvfz php-7.4.5.tar.gz

echo "Getting ready for PHP compile ..."
cd php-7.4.5
./buildconf --force

echo "Run revised configure string ..."
./configure  --prefix=/usr --sysconfdir=/etc --localstatedir=/var --datadir=/usr/share/php --mandir=/usr/share/man --enable-fpm --with-fpm-user=apache --with-fpm-group=apache --with-config-file-path=/etc --with-zlib --enable-bcmath --with-bz2 --enable-calendar --enable-dba=shared --with-gdbm --with-gmp --enable-ftp --with-gettext=/usr --enable-mbstring --enable-pcntl --with-pspell --with-readline --with-snmp --with-mysql-sock=/run/mysqld/mysqld.sock --with-curl --with-openssl --with-openssl-dir=/usr --with-mhash --enable-intl --with-libdir=/lib64 --enable-sockets --with-libxml --enable-soap --enable-gd --with-jpeg --with-freetype-dir=/usr --enable-exif --with-xsl --with-xmlrpc --with-pgsql --with-pdo-mysql=/usr --with-pdo-pgsql --with-mysqli --with-mssql --with-pdo-dblib --with-ldap --with-ldap-sasl --enable-shmop --enable-sysvsem --enable-sysvshm --enable-sysvmsg --with-tidy --with-expat --with-enchant --with-imap=/usr/local/imap-2007f --with-imap-ssl=/usr/include/openssl --with-kerberos=/usr/include/krb5 --with-sodium=/usr --with-zip --enable-opcache --with-pear --with-ffi

echo "Making and installing PHP ..."
make
make install

echo "Making PHP available via FPM ..."
install -v -m644 php.ini-production /etc/php.ini
cp -v /etc/php-fpm.conf.default /etc/php-fpm.conf
cp -v /etc/php-fpm.d/www.conf.default /etc/php-fpm.d/www.conf
sed -i 's@php/includes"@&\ninclude_path = ".:/usr/lib/php"@' /etc/php.ini
sed -i -e '/proxy_module/s/^#//' -e '/proxy_fcgi_module/s/^#//' /etc/httpd/httpd.conf
echo 'ProxyPassMatch ^/(.*.php)$ fcgi://127.0.0.1:9000/srv/www/$1' >> /etc/httpd/httpd.conf
sed -i 's/DirectoryIndex index.html/DirectoryIndex index.php index.html/' /etc/httpd/httpd.conf

echo "Starting up services ..."
/etc/init.d/mysql start
/usr/sbin/php-fpm &
/etc/init.d/httpd start
