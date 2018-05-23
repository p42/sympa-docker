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

OPTIONAL environment variables and their defaults:
SYMPA_RUN_SPECIAL=FALSE (You'll need to set this to TRUE yourself)
SYMPA_RUN_NAME=NONE (to use this it should be a URL without the /filename at the end.)
SYMPA_RUN_URL=NONE (this is the filename that should be called.)

There is a script that runs as part of the container setup
that looks for these variables and tries to include the requested
file and run it as a script.  To use this feature change
SYMPA_RUN_SPECIAL to TRUE, and add the URL and file name to their
respective variables

The following internal container directories expect persistence:
/etc/sympa
/var/lib/sympa
/var/spool/postfix
/var/spool/sympa

This is accomplised by mounting a single volume into a fixed
directory inside the container.  Then on the mounted volume four
subdirectorys are created and then the original locations are symlinked
to their persistent locations.

sample run command looks like:

docker run -p 80:80 -p 25:25 -e SYMPA_DOMAIN=lists.mydomain.com \
-e SYMPA_DB_TYPE=mysql -e SYMPA_DB_HOST=localhost -e SYMPA_DB_USER=sympa \
-e SYMPA_DB_PASS=sympa -e SYMPA_DB_NAME=sympa -e SYMPA_LISTMASTERS=csv_list_of_emails \
-e SYMPA_POSTFIX_RELAY=mail.mydomain.com -v datasource:/sympa_perm project42/sympa

NOTE: You can omit the SYMPA_POSTFIX_RELAY environment variable to have the sympa
container drop mail directly to the internet.  NO provision is made for DKIM or any other
mail security feature.

A couple lines added by Brandon as a test.
