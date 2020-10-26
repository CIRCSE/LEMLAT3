#!/bin/bash

set -e

USER_NAME=paolo
HOST_NAME=itreebank.marginalia.it
DUMP_FILE=lemlat_db_REMOTE_$(date +%d-%m-%Y).sql

echo "get remote dump into file: $DUMP_FILE"
echo "You will be asked for REMOTE DB PASSWORD"
echo "For  HOST: $HOST_NAME"
echo "and  USER: $USER_NAME"
echo
mysqldump -h$HOST_NAME -u$USER_NAME -p  --routines --triggers --databases lemlat_db |\
 sed 's/DEFINER=[^*]*\*/\*/g' | sed 's/DEFINER=[^ ]* / /g'  > $DUMP_FILE  

gzip $DUMP_FILE

