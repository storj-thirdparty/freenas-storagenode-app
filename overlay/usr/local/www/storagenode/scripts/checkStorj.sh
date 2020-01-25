#!/usr/local/bin/bash

process="/usr/local/www/storagenode/scripts/storagenode"
user=www
ps=` ps -adf | grep $process | grep -v grep `
cmd=" ps -adf | grep $process | grep -v grep | wc -l"
numLines=`eval $cmd`

if [[ $numLines -ge 1 ]]
then
	echo "Service $process is running (lines:$numLines) and processes: $ps "
else
	echo "Service $process is not running "
fi
