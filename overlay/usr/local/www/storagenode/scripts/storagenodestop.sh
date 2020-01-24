#!/usr/local/bin/bash
# This script Stops the docker image of storagenode and removes it
SYNOPKG_PKGNAME="StorJ"
LOG="/var/log/$SYNOPKG_PKGNAME"
echo `date` "Storagenode is stopping" >> $LOG
DESTDIR=/volume1/@appstore/StorJ/scripts/docker-compose.yml
ERRLOG="$LOG"_ERR
rm -f "$ERRLOG"
#
#
#${DOCKER} run -d --restart unless-stopped -p "$2":28967 -p 14002:14002 -e WALLET="$3" -e EMAIL="dummy@gmail.com" -e ADDRESS="68.55.169.100:${2}" -e BANDWIDTH="${5}TB" -e STORAGE="${4}GB" --mount type=bind,source="${6}",destination=/app/identity --mount type=bind,source="/share/CACHEDEV1_DATA/storj/",destination=/app/config --name ${QPKG_NAME} storjlabs/storagenode:latest 2>&1
#docker run -d --restart unless-stopped -p 28967:28967 -p 14002:14002 -e WALLET="0xXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX" -e EMAIL="user@example.com" -e ADDRESS="173.225.183.160:28967" -e BANDWIDTH="20TB" -e STORAGE="2TB" --mount type=bind,source="/homes/Identity/storagenode",destination=/app/identity --mount type=bind,source="/volume1/StorJ",destination=/app/config --name storagenode storjlabs/storagenode:latest
docker stop storagenode
docker rm -f storagenode
 #Logging error
if [ -s "$ERRLOG" ]; then
  echo `date` "----------------------------------------------------"
  cat $ERRLOG
  echo `date` "----------------------------------------------------"
  # Add information to the log to be displayed by the Catalog Manager
  echo `date` "Adding info to the  log file"
  sed -i 's/$/<br>/' "$ERRLOG"
  cat $ERRLOG >> $SYNOPKG_TEMP_LOGFILE
  exit 1
fi
