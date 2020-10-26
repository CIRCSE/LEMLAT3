#!/bin/bash

DUMP_FILE=LOCAL_lemlat_db_$(date +%d-%m-%Y).sql

echo "get local dump into file: $DUMP_FILE"
echo "You will be asked for LOCAL DB PASSWORD"
echo
mysqldump -uroot -p lemlat_db | \
sed 's/DEFINER=[^*]*\*/\*/g' > $DUMP_FILE  

gzip $DUMP_FILE
