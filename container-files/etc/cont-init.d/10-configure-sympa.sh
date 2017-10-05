#!/usr/bin/with-contenv /bin/bash

set -e
#copy staging area files into permanant locations

# fix permissions on volume mounts
chmod -R 777 /etc/sympa
chmod -R 777 /var/lib/sympa
chmod -R 777 /var/spool/sympa
chmod -R 777 /var/spool/postfix

if [ ! -e /etc/sympa/staged_files ]; then
  rsync -a -r /keep/sympaetc/ /etc/sympa/
  touch /etc/sympa/staged_files
fi

if [ ! -e /var/lib/sympa/staged_files ]; then
  rsync -a -r /keep/sympalib/ /var/lib/sympa/
  touch /var/lib/sympa/staged_files
fi

if [ ! -e /var/spool/postfix/staged_files ]; then
  rsync -a -r /keep/postfixspool/ /var/spool/postfix/
  touch /var/spool/postfix/staged_files
fi

#Apply environment variables to config files where needed.

# SYMPA_DOMAIN
if [ "$SYMPA_DOMAIN" != "lists.mydomain.com" ]; then
	sed -e "s/SYMPA_DOMAIN/$SYMPA_DOMAIN/g" /etc/nginx/conf.d/sympa.conf > /etc/nginx/conf.d/sympa.conf.new
	sed -e "s/SYMPA_DOMAIN/$SYMPA_DOMAIN/g" /etc/nginx/nginx.conf > /etc/nginx/nginx.conf.new
  sed -e "s/SYMPA_DOMAIN/$SYMPA_DOMAIN/g" /etc/sympa/sympa.conf > /etc/sympa/sympa.conf.new
	sed -e "s/SYMPA_DOMAIN/$SYMPA_DOMAIN/g" /etc/postfix/main.cf > /etc/postfix/main.cf.new
	sed -e "s/my.domain.org/$SYMPA_DOMAIN/g" /etc/sympa/aliases.sympa.postfix > /etc/sympa/aliases.sympa.postfix.new
	mv /etc/nginx/conf.d/sympa.conf.new /etc/nginx/conf.d/sympa.conf
  mv /etc/nginx/nginx.conf.new /etc/nginx/nginx.conf
	mv /etc/sympa/sympa.conf.new /etc/sympa/sympa.conf
	mv /etc/postfix/main.cf.new /etc/postfix/main.cf
  mv /etc/sympa/aliases.sympa.postfix.new /etc/sympa/aliases.sympa.postfix
fi

#set db type in sympa config file
sed -e "s/SYMPA_DB_TYPE/$SYMPA_DB_TYPE/g" /etc/sympa/sympa.conf > /etc/sympa/sympa.conf.new
mv /etc/sympa/sympa.conf.new /etc/sympa/sympa.conf

#set db host in sympa config file
sed -e "s/SYMPA_DB_HOST/$SYMPA_DB_HOST/g" /etc/sympa/sympa.conf > /etc/sympa/sympa.conf.new
mv /etc/sympa/sympa.conf.new /etc/sympa/sympa.conf

#set db user in sympa config file
sed -e "s/SYMPA_DB_USER/$SYMPA_DB_USER/g" /etc/sympa/sympa.conf > /etc/sympa/sympa.conf.new
mv /etc/sympa/sympa.conf.new /etc/sympa/sympa.conf

#set db password in sympa config file
sed -e "s/SYMPA_DB_PASS/$SYMPA_DB_PASS/g" /etc/sympa/sympa.conf > /etc/sympa/sympa.conf.new
mv /etc/sympa/sympa.conf.new /etc/sympa/sympa.conf

#set db name in sympa config file
sed -e "s/SYMPA_DB_NAME/$SYMPA_DB_NAME/g" /etc/sympa/sympa.conf > /etc/sympa/sympa.conf.new
mv /etc/sympa/sympa.conf.new /etc/sympa/sympa.conf

#set sympa listmasters in sympa config file
sed -e "s/SYMPA_LISTMASTERS/$SYMPA_LISTMASTERS/g" /etc/sympa/sympa.conf > /etc/sympa/sympa.conf.new
mv /etc/sympa/sympa.conf.new /etc/sympa/sympa.conf

# apply relayhost to postfix config if requested.

if [ "$SYMPA_POSTFIX_RELAY" != "mail.mydomain.com" ]; then
	sed -e "s/#relayhost = SYMPA_POSTFIX_RELAY/relayhost = $SYMPA_POSTFIX_RELAY/g" /etc/postfix/main.cf > /etc/postfix/main.cf.new
	mv /etc/postfix/main.cf.new /etc/postfix/main.cf
fi

if [ "$SYMPA_REMOTE_LOG_SERVER" != "logger.mydomain.com" ]; then
	sed -e "s/#*.* @remote-host:514/*.* @$SYMPA_REMOTE_LOG_SERVER/g" /etc/rsyslog.conf > /etc/rsyslog.conf.new
	mv /etc/rsyslog.conf.new /etc/rsyslog.conf
fi


# Configuration complete

# test to see if migration is needed and migrate data if needed