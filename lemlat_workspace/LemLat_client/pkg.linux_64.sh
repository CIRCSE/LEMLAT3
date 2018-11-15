#!/bin/bash

mkdir linux_client
cp  bin.linux/debug/lemlat_client linux_client
cp  bin.linux/debug/my.cnf.sample linux_client
cp  bin.linux/debug/lemlat.dtd linux_client
tar --remove-files -czf linux_client_64.tar.gz linux_client

mkdir linux_embedded
cp    bin.linux/embeddedD/lemlat linux_embedded
cp    bin.linux/embeddedD/my.cnf linux_embedded
cp    bin.linux/embeddedD/lemlat.dtd linux_embedded
cp -r bin.linux/embeddedD/data linux_embedded
cp -r bin.linux/embeddedD/share linux_embedded
tar --remove-files -czf linux_embedded_64.tar.gz linux_embedded

