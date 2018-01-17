### About this Repo

This is a docker container running nginx, postfix,
and sympa from the sympa-ja repo.

The containter supports these environment
variables (along with their default values)
that must be set in order for the container to run
correctly:

SYMPA_DOMAIN=lists.mydomain.com
SYMPA_DB_TYPE=mysql
SYMPA_DB_HOST=localhost
SYMPA_DB_USER=sympa
SYMPA_DB_PASS=sympa
SYMPA_DB_NAME=sympa
SYMPA_LISTMASTERS=myadmin@mydomain.com
SYMPA_POSTFIX_RELAY=mail.mydomain.com

The following internal container directories expect persistence:
/etc/sympa
/var/lib/sympa
/var/spool/postfix
/var/spool/sympa

sample run command looks like:

docker run -p 80:80 -p 25:25 -e SYMPA_DOMAIN=lists.mydomain.com \
-e SYMPA_DB_TYPE=mysql -e SYMPA_DB_HOST=localhost -e SYMPA_DB_USER=sympa \
-e SYMPA_DB_PASS=sympa -e SYMPA_DB_NAME=sympa -v datasource:/sympa_perm \
 project42/sympa
