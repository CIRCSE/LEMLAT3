#!/bin/bash

# check/make support directories
mkdir -p ../LemLat_client/debug.linux
mkdir -p ../LemLatDB/debug.linux
mkdir -p ../LemLatLIB/debug.linux
mkdir -p ../mysqlUtil/debug.linux
mkdir -p ../LemLatDB/lib.linux/debug
mkdir -p ../LemLatLIB/lib.linux/debug
mkdir -p ../mysqlUtil/lib.linux/debug

cd ../mysqlUtil/
make -f Makefile.linux 

cd ../LemLatDB/
make -f Makefile.linux dtn


cd ../LemLatLIB/
make -f Makefile.linux 


cd ../LemLat_client/
make -f Makefile.linux client_64
make -f Makefile.linux embedded_64

