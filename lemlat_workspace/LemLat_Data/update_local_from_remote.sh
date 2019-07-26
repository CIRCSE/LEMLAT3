#!/bin/bash

set -e

DUMP_FILE=lemlat_db_derivational_db_$(date +%d-%m-%Y).sql
REMOTE_USER="paolo"
REMOTE_HOST="itreebank.marginalia.it"

LOCAL_USER="lemlat"

echo "get remote dump into file: $DUMP_FILE"
echo "You will be asked for REMOTE DB PASSWORD"
echo "=====USER:$REMOTE_USER"
echo "=====HOST:$REMOTE_HOST"
echo
mysqldump -h$REMOTE_HOST -u$REMOTE_USER -p --databases lemlat_db derivational_db |\
sed  's/DEFINER=[^*]*\*/\*/g' > $DUMP_FILE


echo
echo "upating local db from file: $DUMP_FILE"
echo "You will be asked for LOCAL DB PASSWORD"  
echo "=====LOCAL USER:$LOCAL_USER"
echo
mysql -u$LOCAL_USER -p < $DUMP_FILE

echo
echo "upating lemlat_db wfr table."
echo "You will be asked for LOCAL DB PASSWORD"  
echo
mysql -u$LOCAL_USER -p lemlat_db < create_wfr_lemmas_table.sql
