
CONFIG = "srcs/docker-compose.yml"

# directory for services volumes
DATA = "${HOME}/data"


all: build up


# build all services specified in srcs/docker-compose.yml
# services: Nginx, MariaDB, WordPress
build:
	docker-compose build ${CONFIG}

