#!/usr/local/bin/bash

process='/usr[/]*local[/]*www[/]*storagenode[/]*scripts[/]*storagenode'
user=storj
cmd=" ps -adf -U $user | grep -E -e \"$process\" | grep -v grep | wc -l"
numLines=$(eval "$cmd")

process=$(basename "$process")
if [[ $numLines -ge 1 ]]
then
	echo 1
else
	echo 0
fi
