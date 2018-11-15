#!/bin/bash

mkdir osx_client
cp  bin.osx/debug/lemlat_client osx_client
cp  bin.osx/debug/my.cnf.sample osx_client
#tar --remove-files -czf osx_client.tar.gz osx_client
tar -czf osx_client.tar.gz osx_client
rm -rf osx_client

mkdir osx_embedded
cp    bin.osx/embeddedD/lemlat osx_embedded
cp    bin.osx/embeddedD/my.cnf osx_embedded
cp -r bin.osx/embeddedD/data osx_embedded
cp -r bin.osx/embeddedD/share osx_embedded
#tar --remove-files -czf osx_embedded.tar.gz osx_embedded
tar -czf osx_embedded.tar.gz osx_embedded
rm -rf osx_embedded
