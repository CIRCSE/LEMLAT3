bin/mysql --defaults-file=my_gen.cnf -h127.0.0.1 -uroot -P63301 -e "CREATE DATABASE IF NOT EXISTS lemlat_db"
bin/mysql --defaults-file=my_gen.cnf -h127.0.0.1 -uroot -P63301 lemlat_db < $1

