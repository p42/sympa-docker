FROM debian:9.1
MAINTAINER Rance Hall rance_hall@icloud.com

ENV DEBIAN_FRONTEND noninteractive
ENV SYMPA_RELEASE 6.2.16
ENV S6_RELEASE v1.20.0.0/s6-overlay-amd64.tar.gz

#Add S6 Overlay (Build via Docker 1.12)
#ADD https://github.com/just-containers/s6-overlay/releases/download/$S6_RELEASE /tmp/
#RUN tar xzf /tmp/s6-overlay-amd64.tar.gz -C / --exclude="./bin" \
# && tar xzf /tmp/s6-overlay-amd64.tar.gz -C /usr ./bin

#Add S6 Overlay (Build via Docker CE 17)
ADD https://github.com/just-containers/s6-overlay/releases/download/$S6_RELEASE /tmp/
RUN mv /tmp/bin/* /usr/bin/ \
 && mv /tmp/etc/* /etc/ \
 && mv /tmp/init / \
 && mv /tmp/libexec/ / \
 && rm -v /tmp/usr/bin/execlineb \
 && mv /tmp/usr/bin/* /usr/bin/ \
 && rm -rfv /tmp/*


#Install Sympa required packages
RUN apt-get update \
 && apt-get install apt-utils -y \
 && apt-get install less -y \
 && apt-get install nano -y \
 && apt-get install nginx -y \
 && apt-get install perl -y \
 && apt-get install postfix -y \
 && apt-get install build-essential -y \
 && apt-get install libglib2.0-data shared-mime-info libio-socket-ip-perl libio-socket-inet6-perl krb5-locales libmime-types-perl libsasl2-modules libhtml-form-perl libhttp-daemon-perl libxml-sax-expat-perl xml-core libfile-nfslock-perl libsoap-lite-perl libcrypt-ciphersaber-perl libmail-dkim-perl -y

#Install Sympa
ADD http://www.sympa.org/distribution/sympa-$SYMPA_RELEASE.tar.gz /tmp/

#Create sympa user
RUN groupadd -r sympa && useradd -g sympa -m -r -s /bin/bash sympa

#Configure, make, and make install sympa
RUN cd /tmp/sympa-$SYMPA_RELEASE && ./configure && make && make install

#Configure web server
RUN echo "daemon off;" >> /etc/nginx/nginx.conf

#Configure postfix mailer daemon

#Add Service NGINX to be Monitored by S6
RUN mkdir -p /etc/services.d/nginx/ \
 && touch /etc/services.d/nginx/run \
 && echo '#!/usr/bin/execlineb -P' > /etc/services.d/nginx/run \
 && echo 'nginx' >> /etc/services.d/nginx/run

#Add Service POSTFIX to be Monitored by S6
RUN mkdir -p /etc/services.d/postfix/
COPY postfix.run /etc/services.d/postfix/run

ENTRYPOINT ["/init"]
