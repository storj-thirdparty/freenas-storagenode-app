#!/usr/local/bin/bash

#numLines=`docker ps  --filter name="^docker_db_1$" | wc -l `

container=storagenode
cmd="docker ps -a --filter name=\"^/${container}$\" | wc -l"
#echo "Running #$cmd#"
numLines=`eval $cmd`



if [[ $numLines -gt 1 ]]
then
	statuscmd="docker ps -a --filter name=\"^/${container}$\"  | cut -c86-109 "
	status=`eval $statuscmd `

	echo "Container named $container launched <br> "
	echo "$status "
else
	echo "Container named $container not launched  "
fi
