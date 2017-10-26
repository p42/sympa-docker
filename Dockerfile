FROM project42/syslog-centos:centos7
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
 && yum -y install telnet mailx \
 && yum -y install epel-release \
 && yum -y install sympa-6.2.20-1.20170923.RHEL7.x86_64 sympa-nginx-6.2.20-1.20170923.RHEL7.x86_64 \
 && yum -y install postfix rsync \
 && rpm -e --nodeps ssmtp \
 && yum -y clean all

#RUN ln -s /usr/bin/perl /bin/perl

RUN chmod +x /usr/sbin/presympa

# address data persistence needs for files in:
#/etc/sympa
#/var/lib/sympa
#/var/spool/postfix
#/var/spool/sympa  #/var/spool/sympa not created by rpm package.  Created on first run of sympa.


RUN mkdir -p /keep/sympaetc \
&& mkdir -p /keep/sympalib \
&& mkdir -p /keep/postfixspool \
&& rsync -a -r /etc/sympa/ /keep/sympaetc/ \
&& rsync -a -r /var/lib/sympa/ /keep/sympalib/ \
&& rsync -a -r /var/spool/postfix/ /keep/postfixspool/



ENTRYPOINT ["/init"]
