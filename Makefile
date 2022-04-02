
CONFIG = "srcs/docker-compose.yml"

# volumes directories
DATA = "${HOME}/data"
WORDPRESS_DATA = ${DATA}/wordpress
MARIADB_DATA = ${DATA}/mariadb


all: build up


# build all services specified in CONFIG
# services: Nginx, MariaDB, WordPress
build:
	mkdir -p ${DATA}
	mkdir -p ${WORDPRESS_DATA}
	mkdir -p ${MARIADB_DATA}
	docker-compose -f ${CONFIG} build

up:
	docker-compose -f ${CONFIG} up -d

