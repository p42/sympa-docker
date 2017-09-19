#!/usr/bin/with-contenv /bin/bash

set -e

#Apply environment variables to config files where needed.

# SYMPA_DOMAIN
if [ "$SYMPA_DOMAIN" != "lists.mydomain.com" ]; then
	sed -e "s/SYMPA_DOMAIN/$SYMPA_DOMAIN/g" /etc/nginx/conf.d/sympa.conf > /etc/nginx/conf.d/sympa.conf.new
  sed -e "s/SYMPA_DOMAIN/$SYMPA_DOMAIN/g" /etc/sympa/sympa.conf > /etc/sympa/sympa.conf.new
	mv /etc/nginx/conf.d/sympa.conf.new /etc/nginx/conf.d/sympa.conf
	mv /etc/sympa/sympa.conf.new /etc/sympa/sympa.conf
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
	sed -e "s/#*.* @@remote-host:514/*.* @@$SYMPA_REMOTE_LOG_SERVER/g" /etc/rsyslog.conf > /etc/rsyslog.conf.new
	mv /etc/rsyslog.conf.new /etc/rsyslog.conf
fi

# Configuration complete
