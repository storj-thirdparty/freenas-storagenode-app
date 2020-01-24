#!/usr/local/bin/bash

# This script updates the storagenode docker image

SYNOPKG_PKGNAME="StorJ"
LOG="/var/log/$SYNOPKG_PKGNAME"
echo `date` $SYNOPKG_PKGNAME  "is updating" >> $LOG

ERRLOG="$LOG"_ERR
rm -f "$ERRLOG"













if [ -s "$ERRLOG" ]; then
  echo `date` "----------------------------------------------------"
  cat $ERRLOG
  echo `date` "----------------------------------------------------"
  # Add infor to the log to be displayed by the Catalog Manager
  echo `date` "Adding info to the  POST INSTALL log file"
  sed -i 's/$/<br>/' "$ERRLOG"
  cat $ERRLOG >> $SYNOPKG_TEMP_LOGFILE
  exit 1
fi





