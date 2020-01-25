#!/usr/local/bin/bash

process="/usr/local/www/storagenode/scripts/storagenode"
user=www
cmd=" ps -adf -U $user | grep $process | grep -v grep | wc -l"
numLines=`eval $cmd`

process=$(basename $process)
if [[ $numLines -ge 1 ]]
then
	echo "Service $process is running "
else
	echo "Service $process is not running "
fi
