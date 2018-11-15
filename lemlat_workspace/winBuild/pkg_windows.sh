#!/bin/bash

mkdir -p windows_client
cp ./bin/Release/lemlat_client windows_client
cp ./bin/Release/my.cnf.sample windows_client
cp ./bin/Release/lemlat.dtd windows_client
zip -rm windows_client.zip windows_client

mkdir -p windows_embedded
cp ./bin/ReleaseEmb/lemlat windows_embedded
cp ./bin/ReleaseEmb/my.cnf windows_embedded
cp ./bin/ReleaseEmb/lemlat.dtd windows_embedded
cp -r ./bin/ReleaseEmb/data windows_embedded
cp -r ./bin/ReleaseEmb/share windows_embedded
zip -rm windows_embedded.zip windows_embedded
