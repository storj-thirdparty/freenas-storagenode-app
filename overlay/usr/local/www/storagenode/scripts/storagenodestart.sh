#!/usr/local/bin/bash
# This script starts storagenode 
PKGNAME="STORJ"
LOG="/var/log/$PKGNAME"
HOME=/root
echo `date` "Storagenode is starting" >> $LOG


#identity_path="$HOME/storj/identity/storagenode"
#port_forwarding=28967
#operator_wallet="0x9318Ee545bC1b05859ac714682684A4F08EDF762"
#operator_email="partnerships@storj.io" 
#allocated_disk_space="1TB"
#allocated_bandwidth="2TB"
#storage_folder="$HOME/storj/config/storage"

if [[ $# -lt 6 ]]
then
	echo $(date) "Not enough params " >> $LOG
	exit
else
	echo $(date) "Parmas given($#): $* " >> $LOG
fi


port_forwarding=$1
operator_wallet=$2
#allocated_bandwidth=$3
allocated_disk_space=$3
identity_path=$4
#identity_path=/root/.local/share/storj/identity/storagenode
storage_folder=$5
STORAGE_NODE_BINARY_PATH=$6
operator_email=$7
certificate_file="${identity_path}/identity.cert"
key_file="${identity_path}/identity.key"
config_folder=`dirname ${storage_folder}`
trust_cache_file="${config_folder}/trust-cache.json"

addonparams="--metrics.app-suffix=-alpha --console.address=:14002 --metrics.interval=30m " 


echo `date` "Running storagenode binary ${STORBIN} for setup" >> $LOG
cmd="$STORAGE_NODE_BINARY_PATH setup --config-dir ${config_folder} --identity-dir ${identity_path} --server.revocation-dburl bolt://${config_folder}/revocations.db --storage2.trust.cache-path ${config_folder}/trust-cache.json --storage2.monitor.minimum-disk-space 500GB  "
echo `date` " $cmd " >> $LOG 2>&1 
$cmd >> $LOG 2>&1 

echo $(date) " Starting Storagenode ---> " >> $LOG

if [[ $# -ge 7 ]]
then
    cmd="nohup ${STORAGE_NODE_BINARY_PATH} run --identity-dir ${identity_path} --config-dir ${config_folder} --operator.email ${operator_email} --operator.wallet ${operator_wallet} --storage.allocated-disk-space ${allocated_disk_space}GB --storage.path ${storage_folder} --identity.cert-path ${certificate_file} --identity.key-path ${key_file} --storage2.trust.cache-path ${trust_cache_file} ${addonparams} "
else
    cmd="nohup ${STORAGE_NODE_BINARY_PATH} run --identity-dir ${identity_path} --config-dir ${config_folder} --operator.wallet ${operator_wallet} --storage.allocated-disk-space ${allocated_disk_space}GB --storage.path ${storage_folder} --identity.cert-path ${certificate_file} --identity.key-path ${key_file} --storage2.trust.cache-path ${trust_cache_file} ${addonparams} "
fi
echo $cmd >> $LOG 

rm -f /tmp/nohup.out
output=` ${cmd} > /tmp/nohup.out 2>&1  & `
echo $output
sleep 3 ; 
cat /tmp/nohup.out
cat /tmp/nohup.out >> $LOG

