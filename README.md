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
