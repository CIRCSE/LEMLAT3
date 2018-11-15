#!/bin/bash



cd ../mysqlUtil/
make -f Makefile.linux clean_all 

cd ../LemLatDB/
make -f Makefile.linux clean_all


cd ../LemLatLIB/
make -f Makefile.linux clean_all


cd ../LemLat_client/
make -f Makefile.linux clean_all
 

