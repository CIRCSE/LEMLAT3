#!/bin/bash

DUMP_FILE=lemlat_db_derivational_db_$(date +%d-%m-%Y).sql

echo "get remote dump into file: $DUMP_FILE"
echo "You will be asked for REMOTE DB PASSWORD"
echo
mysqldump -hitreebank.marginalia.it -upassarotti -p --databases lemlat_db derivational_db |\
 sed -i 's/DEFINER=[^*]*\*/\*/g' > $DUMP_FILE  


echo
echo "upating local db from file: $DUMP_FILE"
echo "You will be asked for LOCAL DB PASSWORD"  
echo
mysql -uroot -p < $DUMP_FILE

echo
echo "upating lemlat_db wfr table."
echo "You will be asked for LOCAL DB PASSWORD"  
echo
mysql -uroot -p lemlat_db < create_wfr_lemmas_table.sql
