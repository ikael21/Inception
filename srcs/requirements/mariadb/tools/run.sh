#!/bin/sh

DB_INIT="db-init"

# create mariadb socket directory if not exists
if [ ! -d "/run/mysqld" ];
then
	mkdir -p /run/mysqld
fi
chown -R 'mysql:mysql' /run/mysqld

# basic install
chown -R mysql:mysql /var/lib/mysql
mysql_install_db --user=mysql --ldata=/var/lib/mysql > /dev/null

# database init
cat << EOF > $DB_INIT
USE mysql;
FLUSH PRIVILEGES;
GRANT ALL ON *.* TO 'root'@'%'
IDENTIFIED BY '$MYSQL_ROOT_PASSWORD'
WITH GRANT OPTION;
SET PASSWORD FOR 'root'@'%'=PASSWORD('$MYSQL_ROOT_PASSWORD');
DROP DATABASE IF EXISTS test;
FLUSH PRIVILEGES;
CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE
CHARACTER SET utf8 COLLATE utf8_general_ci;
GRANT ALL ON wordpress.* TO '$MYSQL_USER'@'%'
IDENTIFIED BY '$MYSQL_PASSWORD';
EOF

# apply database init
/usr/bin/mysqld --user=mysql --bootstrap \
                --verbose=0 --skip-name-resolve \
                --skip-networking=0 < $DB_INIT
rm -f $DB_INIT

# MariaDB docker container entrypoint
exec /usr/bin/mysqld --user=mysql \
                     --console --skip-name-resolve \
                     --skip-networking=0 $@
