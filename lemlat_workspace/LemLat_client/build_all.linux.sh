#!/bin/bash



cd ../mysqlUtil/
make -f Makefile.linux 

cd ../LemLatDB/
make -f Makefile.linux dtn


cd ../LemLatLIB/
make -f Makefile.linux 


cd ../LemLat_client/
make -f Makefile.linux client
make -f Makefile.linux embedded  

