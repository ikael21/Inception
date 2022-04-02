# base layer
FROM alpine:3.14

ARG PACKAGES="mariadb \
              mariadb-common \
              mariadb-server-utils"

RUN apk update && \
	apk upgrade && \
	apk add --update --no-cache $PACKAGES

WORKDIR /scripts
COPY ./tools/run.sh .

EXPOSE 3306

ENTRYPOINT ["/bin/sh", "run.sh"]
