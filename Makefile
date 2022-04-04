
CONFIG = "srcs/docker-compose.yml"

# volumes directories
DATA = "${HOME}/data"
WORDPRESS_DATA = ${DATA}/wordpress
MARIADB_DATA = ${DATA}/mariadb

#colors for beauty
YELLOW = \033[33;1m
RESET = \033[0m
GREEN = \033[32;1m
MAGENTA = \033[35;1m


.PHONY: all build up down reset help


all: build up

# build all services specified in CONFIG
# services: Nginx, MariaDB, WordPress
build:
	mkdir -p ${WORDPRESS_DATA}
	mkdir -p ${MARIADB_DATA}
	docker-compose -f ${CONFIG} build

# runs services
up:
	docker-compose -f ${CONFIG} up -d

# stops services
down:
	docker-compose -f $(CONFIG) down

# stops all runnning containers
# removes all containers
# removes all local container images
# removes all volumes
reset:
	-docker stop $(shell docker ps -qa)
	-docker rm $(shell docker ps -qa)
	-docker rmi -f $(shell docker images -qa)
	-docker volume rm $(shell docker volume ls -q)

help:
	@echo "${MAGENTA}	USAGE${RESET}"
	@echo "${GREEN}make | make all    ${YELLOW}executes build and up rules${RESET}"
	@echo "${GREEN}make build         ${YELLOW}build specified container images${RESET}"
	@echo "${GREEN}make up            ${YELLOW}launch containers that was built by ${GREEN}make build${RESET}"
	@echo "${GREEN}make reset${RESET}:"
	@echo "	${YELLOW}1. Stops all runnning containers${RESET}"
	@echo "	${YELLOW}2. Removes all containers${RESET}"
	@echo "	${YELLOW}3. Removes all local container images${RESET}"
	@echo "	${YELLOW}4. Removes all volumes${RESET}"
