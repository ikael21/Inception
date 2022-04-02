# base layer
FROM alpine:3.14

ARG WORDPRESS_VOLUME="/var/www/html/wordpress"
ARG WP_CLI="https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar"

ARG PACKAGES="php7 php7-common php7-session php7-iconv \
              php7-json php7-gd php7-curl php7-xml php7-mysqli \
              php7-imap php7-cgi fcgi php7-pdo php7-pdo_mysql \
              php7-soap php7-xmlrpc php7-posix php7-mcrypt \
              php7-gettext php7-ldap php7-ctype php7-dom php7-simplexml \
              php7-fpm php7-opcache php7-phar mariadb-client curl"

RUN apk update && \
	apk upgrade && \
	apk add --update --no-cache $PACKAGES

# download and configure wp-cli
RUN curl -O $WP_CLI && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/bin/wp


WORKDIR /scripts
COPY ./tools/run.sh .

WORKDIR $WORDPRESS_VOLUME

# port for nginx to connect
EXPOSE 9000

ENTRYPOINT ["/bin/sh", "/scripts/run.sh"]
