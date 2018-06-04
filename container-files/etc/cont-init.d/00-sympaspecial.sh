#!/usr/bin/with-contenv /bin/bash

# check to see if we are supposed to run.

if [ "$SYMPA_RUN_SPECIAL" = "TRUE" ]; then

  # make sure the remote url of the script is defined and a file name for the script is defined

  if [ "$SYMPA_RUN_URL" != "NONE" ] && [ "$SYMPA_RUN_NAME" != "NONE" ]; then

    cd /tmp/
    wget $SYMPA_RUN_URL/$SYMPA_RUN_NAME
    chmod +x $SYMPA_RUN_NAME
    ./$SYMPA_RUN_NAME
  fi

fi
