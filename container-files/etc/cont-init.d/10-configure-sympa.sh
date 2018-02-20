#!/usr/bin/with-contenv /bin/bash

set -e
#copy staging area files into permanant locations

# create and fix permissions on volume mounts

if [ ! -e /sympa_perm/sympaetc ]; then
  mkdir -p /sympa_perm/sympaetc
  mkdir -p /sympa_perm/sympalib
  mkdir -p /sympa_perm/sympaspool
  mkdir -p /sympa_perm/postfixspool
  usermod -aG sympa postfix
fi

# create symlinks of subdirs of volume into appropriate places.
if [ -d /etc/sympa ]; then
  rm -r -f /etc/sympa
  rm -r -f /var/lib/sympa
  rm -r -f /var/spool/postfix
  ln -s /sympa_perm/sympaetc /etc/sympa
  ln -s /sympa_perm/sympalib /var/lib/sympa
  ln -s /sympa_perm/sympaspool /var/spool/sympa
  ln -s /sympa_perm/postfixspool /var/spool/postfix
fi

if [ -e /etc/sympa/staged_files ]; then
  SYMPA_VERSION=$(/usr/bin/perl /usr/sbin/sympa.pl -v | cut -d ' ' -f 2)
  OLD_SYMPA_VERSION=$(cat /etc/sympa/staged_files)

  if [ "$SYMPA_VERSION" != "$OLD_SYMPA_VERSION" ]; then
    rm /etc/sympa/staged_files
    rm /var/lib/sympa/staged_files
  fi

fi

if [ ! -e /etc/sympa/staged_files ]; then
  rsync -a /keep/sympaetc/ /etc/sympa/
  echo $SYMPA_VERSION > /etc/sympa/staged_files
fi

if [ ! -e /var/lib/sympa/staged_files ]; then
  rsync -a /keep/sympalib/ /var/lib/sympa/
  echo $SYMPA_VERSION > /var/lib/sympa/staged_files
fi

if [ ! -e /var/spool/postfix/staged_files ]; then
  rsync -a /keep/postfixspool/ /var/spool/postfix/
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
  sed -e "s/lists.mydomain.tld/$SYMPA_DOMAIN/g" /keep/sympalib/transport_regexp.default > /keep/sympalib/transport_regexp.new
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

#Just to be safe, these files need to be writable by postfix.
chown -R sympa:sympa /sympa_perm/sympalib

# fix the list_aliases.tt2 template files
sed -e "s/#\[/\[/g" /usr/share/sympa/default/list_aliases.tt2 > /usr/share/sympa/default/list_aliases.tt2.new
mv /usr/share/sympa/default/list_aliases.tt2.new /usr/share/sympa/default/list_aliases.tt2

# Configuration complete
