set -e

# enter embedded dir
curdir=$(pwd)
cd bin.osx/embeddedD

# start mysql server
sh start_server.sh &
sleep 20

# run client in to upload dump
sh run_query.sh ../../../LemLat_Data/lemlat_db.sql

# stop mysql server
sh stop_server.sh
sleep 20

# delete logfile
rm -f data/*.err

# return to current dir
cd $curdir

