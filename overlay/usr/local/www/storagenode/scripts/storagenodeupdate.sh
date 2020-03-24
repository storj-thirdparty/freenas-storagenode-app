#!/usr/local/bin/bash

# This script updates the storagenode binary
STORBINDIR="/usr/local/www/storagenode/scripts"
STORBIN="${STORBINDIR}/storagenode"
STORBINZIP=/tmp/newstoragenode_freebsd_amd64.zip


PKGNAME="StorJ"
LOG="/var/log/$PKGNAME"
echo `date` "Request for updating storagenode binary " >> $LOG

# Needs to be optimized 

echo "Extracting new stoage binary to $STORBIN "
curl -L --proto-redir http,https -o ${STORBINZIP} https://github.com/storj/storj/releases/download/v1.0.0/storagenode_freebsd_amd64.zip
unzip -d ${STORBINDIR} -j ${STORBINZIP} -o 
chmod a+x ${STORBIN}


