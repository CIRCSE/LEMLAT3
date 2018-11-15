#!/bin/bash



cd ../mysqlUtil/
make -f Makefile.osx 

cd ../LemLatDB/
make -f Makefile.osx dtn


cd ../LemLatLIB/
make -f Makefile.osx 


cd ../LemLat_client/
make -f Makefile.osx client
make -f Makefile.osx embedded  

