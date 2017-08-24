FROM project42/s6-centos:centos7
MAINTAINER Rance Hall rance_hall@icloud.com

COPY container-files /

RUN cp /sympa-ja.org.rhel.repo /etc/yum.repos.d/  && yum -y update  && yum -y install epel-release && yum -y install sympa && yum -y install sympa-nginx

ENTRYPOINT ["/init"]
