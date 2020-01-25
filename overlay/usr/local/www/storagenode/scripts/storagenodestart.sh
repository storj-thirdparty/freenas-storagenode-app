#!/usr/local/bin/bash
# This script starts storagenode 
SYNOPKG_PKGNAME="StorJ"
LOG="/var/log/$SYNOPKG_PKGNAME"
HOME=/root
echo `date` "Storagenode is starting" >> $LOG


#identity_path="$HOME/storj/identity/storagenode"
#port_forwarding=28967
#operator_wallet="0x9318Ee545bC1b05859ac714682684A4F08EDF762"
#operator_email="partnerships@storj.io" 
#allocated_disk_space="1TB"
#allocated_bandwidth="2TB"
#storage_folder="$HOME/storj/config/storage"

if [[ $# -lt 8 ]]
then
	echo `date` "Not enough params " >> $LOG
	exit
else
	echo `date` "Parmas given($#): $* " >> $LOG
fi


port_forwarding=$1
operator_wallet=$2
operator_email=$3
allocated_bandwidth=$4
allocated_disk_space=$5
identity_path=$6
storage_folder=$7
STORAGE_NODE_BINARY_PATH=$8
certificate_file="${identity_path}/identity.cert"
key_file="${identity_path}/identity.key"
config_folder=`dirname ${storage_folder}`
trust_cache_file="${config_folder}/trust-cache.json"

cmd="nohup ${STORAGE_NODE_BINARY_PATH} run --identity-dir ${identity_path} --config-dir ${config_folder} --operator.email ${operator_email} --operator.wallet ${operator_wallet} --storage.allocated-bandwidth ${allocated_bandwidth} --storage.allocated-disk-space ${allocated_disk_space} --storage.path ${storage_folder} --identity.cert-path ${certificate_file} --identity.key-path ${key_file} --storage2.trust.cache-path ${trust_cache_file} "

echo `date` " Starting Storagenode ---> " >> $LOG
echo $cmd >> $LOG 

${cmd} >> $LOG 2>&1  &

