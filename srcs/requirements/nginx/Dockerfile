FROM alpine:3.14

ARG CONFIG_DIR="/etc/nginx/http.d"
ARG PACKAGES="nginx openssl"

# update all packages and install nginx, openssl
RUN apk update && \
    apk upgrade && \
    apk add --update --no-cache $PACKAGES

# generate SSL certificates
RUN openssl req -x509 -nodes -days 365 \
    -subj "/C=RU/ST=KZN/O=Ikael.Inc./CN=ikael.42.fr" \
    -newkey rsa:2048 \
    -keyout /etc/ssl/private/nginx-selfsigned.key \
    -out /etc/ssl/certs/nginx-selfsigned.crt

# create directory to store nginx config
# and copy nginx config file inside this directory
RUN mkdir -p $CONFIG_DIR
COPY ./conf/wordpress.conf $CONFIG_DIR/default.conf

EXPOSE 443

# run nginx as a non-daemon process
ENTRYPOINT ["nginx", "-g", "daemon off;"]
