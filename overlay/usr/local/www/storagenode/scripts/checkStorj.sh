#!/usr/local/bin/bash

service=storagenode
process='/usr[/]*local[/]*www[/]*storagenode[/]*scripts[/]*storagenode'
user=storj
cmd=" ps -adf -U $user | grep -E -e \"$process\" | grep -v grep | wc -l"
numLines=$(eval "$cmd")

process=$(basename "$process")
if [[ $numLines -ge 1 ]]
then
	echo "Service $service is running "
else
	echo "Service $service is not running "
fi
