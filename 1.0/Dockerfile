FROM project42/s6-centos:centos7
MAINTAINER Rance Hall rance_hall@icloud.com

ENV SYMPA_DOMAIN=lists.mydomain.com
ENV SYMPA_DB_TYPE=mysql
ENV SYMPA_DB_HOST=localhost
ENV SYMPA_DB_USER=sympa
ENV SYMPA_DB_PASS=sympa
ENV SYMPA_DB_NAME=sympa
ENV SYMPA_LISTMASTERS=myadmin@mydomain.com
ENV SYMPA_POSTFIX_RELAY=mail.mydomain.com

COPY container-files /

RUN yum -y update  \
 && yum -y install less nano \
 && yum -y install epel-release \
 && yum -y install sympa \
 && yum -y install sympa-nginx \
 && yum -y install postfix \
 && yum -y clean all

ENTRYPOINT ["/init"]
