#!/usr/local/bin/bash

# This script updates the storagenode binary
STORBIN="/usr/local/www/storagenode/scripts/storagenode"

PKGNAME="StorJ"
LOG="/var/log/$PKGNAME"
echo `date` "Request for updating storagenode binary " >> $LOG

# Needs to be optimized 

echo "Extracting new stoage binary to $STORBIN "
curl -o $STORBIN https://alpha.transfer.sh/YzDaj/storagenode
chmod a+x $STORBIN

