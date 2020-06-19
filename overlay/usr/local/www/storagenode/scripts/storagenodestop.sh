#!/usr/local/bin/bash
# This script Stops the service storagenode 

PKGNAME="STORJ"
LOG="/var/log/$PKGNAME"
#USERS="www root"	# Can't work for a WEB based requests
USERS="www"

echo $(date) "Got Request for Stopping Storagenode " >> $LOG


echo $(date) "Parmas given($#): $* " >> $LOG
STORAGE_NODE_BINARY_PATH=/usr/local/www/storagenode/scripts/storagenode
STORAGE_NODE_BINARY=storagenode
for user in $USERS
do
	cmd="killall -u $user ${STORAGE_NODE_BINARY} "
	echo "Stopping $STORAGE_NODE_BINARY "
	echo $(date) $cmd >> $LOG  2>&1 
	output=`${cmd} 2>&1 `
	echo ${output}
	echo ${output} >> $LOG 2>&1 
done

echo $(date) "storagenode stopped request run " >> $LOG
echo "storagenode stopped request run " 

