FROM debian:9.1
MAINTAINER Rance Hall rance_hall@icloud.com

ENV DEBIAN_FRONTEND noninteractive
ENV SYMPA_RELEASE 6.2.16
ENV S6_RELEASE v1.19.1.1/s6-overlay-amd64.tar.gz

#Add S6 Overlay (Build via Docker 1.12)
ADD https://github.com/just-containers/s6-overlay/releases/download/$S6_RELEASE /tmp/
RUN tar xzf /tmp/s6-overlay-amd64.tar.gz -C / --exclude="./bin" \
 && tar xzf /tmp/s6-overlay-amd64.tar.gz -C /usr ./bin

#Install Sympa required packages
RUN apt-get update \
 && apt-get install nginx -y \
 && apt-get install perl -y \
 && apt-get install postfix -y \
 && apt-get install wget -y

#Install Sympa

#Configure web server
RUN echo "daemon off;" >> /etc/nginx/nginx.conf

#Configure postfix mailer daemon

#Add Service NGINX to be Monitored by S6
RUN mkdir -p /etc/services.d/nginx/ \
 && touch /etc/services.d/nginx/run \
 && echo '#!/usr/bin/execlineb -P' > /etc/services.d/nginx/run \
 && echo 'nginx' >> /etc/services.d/nginx/run

#Add Service POSTFIX to be Monitored by S6
RUN mkdir -p /etc/services.d/postfix/ \
 && touch /etc/services.d/postfix/run \
 && echo '#!/usr/bin/execlineb -P' > /etc/services.d/postfix/run \
 && echo 'postfix' >> /etc/services.d/postfix/run

ENTRYPOINT ["/init"]
