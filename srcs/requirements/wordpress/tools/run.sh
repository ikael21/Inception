#!/bin/sh

TMP_FILE="admin_password.txt"

# save admin password inside TMP_FILE
# to not show it in bash history
echo $ADMIN_PASSWORD > $TMP_FILE

# install wordpress
wp core download --allow-root

# create wp-config.php file
wp config create --allow-root \
                 --dbname="$MYSQL_DATABASE" \
                 --dbuser="$MYSQL_USER" \
                 --dbpass="$MYSQL_PASSWORD" \
                 --dbhost="mariadb" \
                 --dbcharset="utf8" \
                 --dbcollate="utf8_general_ci"

# set up wordpress admin
wp core install --allow-root \
                --url="$URL" \
                --admin_user="$ADMIN" \
                --admin_email="$EMAIL" \
                --prompt=admin_password < "$TMP_FILE"

# set up config
chown -R bin:sys /var/www/html/wordpress
chmod -R 775 /var/www/html/wordpress

cat << EOF > /etc/php7/php-fpm.d/www.conf
[www]

user = bin
group = sys

listen = 0.0.0.0:9000
listen.owner = bin
listen.group = sys

pm = dynamic
pm.max_children = 5
pm.start_servers = 2
pm.min_spare_servers = 1
pm.max_spare_servers = 3
EOF

rm -f $TMP_FILE

exec /bin/sh $@
