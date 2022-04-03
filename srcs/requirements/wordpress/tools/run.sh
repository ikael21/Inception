#!/bin/sh

# set up user and group for php-fpm
chown -R bin:sys /var/www/html/wordpress
chmod -R 775 /var/www/html/wordpress

# change default config
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


# install wordpress if not installed
if [ -z "$(ls -A .)" ];
then
    wp core download --allow-root
fi

# create wp-config.php file if not exists
wp config create --allow-root \
                 --dbname="$MYSQL_DATABASE" \
                 --dbuser="$MYSQL_USER" \
                 --dbpass="$MYSQL_PASSWORD" \
                 --dbhost="mariadb" \
                 --dbcharset="utf8" \
                 --dbcollate="utf8_general_ci"

# save admin password inside TMP_FILE
# to not show it in bash history
TMP_FILE="admin_password.txt"
echo $ADMIN_PASSWORD > $TMP_FILE

# set up wordpress admin and delete TMP_FILE after that
wp core install --allow-root \
                --url="$URL" \
                --title="Title" \
                --admin_user="$ADMIN" \
                --admin_email="$EMAIL" \
                --prompt=admin_password < "$TMP_FILE"

rm -f $TMP_FILE

# create simple user (author)
wp user create \
   --allow-root "$USER_LOGIN" "$USER_EMAIL" \
   --user_pass="$USER_PASSWORD" --role="$USER_ROLE"


exec /usr/sbin/php-fpm7 -F $@
