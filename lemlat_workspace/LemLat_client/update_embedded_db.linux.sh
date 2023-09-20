set -e

# enter embedded dir
curdir=$(pwd)
cd bin.linux/embeddedD

# sostuisci path nel template del file di configurazione
sed "s~EMBEDDED_DIRECTORY~$curdir~" my_gen.cnf.TEMPLATE > my_gen.cnf


# start mysql server
sh start_server.sh &
sleep 20

# run client in to upload dump
sh run_query.sh ../../../LemLat_Data/lemlat_db.sql

# stop mysql server
sh stop_server.sh
sleep 20

# delete logfile
# rm -f data/*.err

# return to current dir
cd $curdir

# UPDATE pkg (only data)
tar -xzf linux_embedded_64.tar.gz # crea direcory temporanea
cp -r bin.linux/embeddedD/data linux_embedded
cp -r bin.linux/embeddedD/share linux_embedded
# rimuove directory temporanea
tar --remove-files -czf linux_embedded.tar.gz linux_embedded
