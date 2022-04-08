
CONFIG = "srcs/docker-compose.yml"

# volumes directories
DATA = "${HOME}/data"
WORDPRESS_DATA = ${DATA}/wordpress
MARIADB_DATA = ${DATA}/mariadb


.PHONY: all build up down reset


all: build up

# build all services specified in CONFIG
# services: Nginx, MariaDB, WordPress
build:
	mkdir -p ${WORDPRESS_DATA}
	mkdir -p ${MARIADB_DATA}
	docker-compose -f ${CONFIG} build

# runs services inside the specified srcs/docker-compose.yml
up:
	docker-compose -f ${CONFIG} up -d

# stops services specified in srcs/docker-compose.yml
down:
	docker-compose -f $(CONFIG) down

# stops all runnning containers
# removes all running containers images
# removes all local container images
# removes all volumes
# removes all networks (except default)
reset:
	-docker stop $(shell docker ps -qa) 2> /dev/null
	-docker rm $(shell docker ps -qa) 2> /dev/null
	-docker rmi -f $(shell docker images -qa) 2> /dev/null
	-docker volume rm $(shell docker volume ls -q) 2> /dev/null
	-docker network rm $(shell docker network ls -q) 2> /dev/null
