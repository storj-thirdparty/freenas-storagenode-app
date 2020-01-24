#!/bin/bash

lanid=3
ifconfig lo${lanid} create inet 192.168.0.${lanid} netmask 255.255.255.0

#TODO : Add update pf.conf file for packet filter settings (NAT & listening ports !)
cat >> /etc/rc.sys <<NWIF_DEF
ipv6_network_interfaces="none"
ifconfig_lo${lanid}="inet 192.168.0.${lanid} netmask 255.255.255.0"
NWIF_DEF
service netif restart

cat >> /etc/pf.conf <<PF_CONF_ADDON

# -----------------------------------------------------------
#  Added for Storj Admin Jails NW config
# -----------------------------------------------------------
ext_if="em0"
storagenodejail="192.168.0.3"
nat on \$ext_if from \$storagenodejail to any -> (\$ext_if)

#Redirect web traffic for stoj admin to the jail.
webport=8080
rdr on \$ext_if proto tcp from any to (\$ext_if) port \$webport -> \$storagenodejail port http
pass in on \$ext_if proto tcp to \$storagenodejail port { http, https } keep state

# -----------------------------------------------------------

PF_CONF_ADDON
sysrc pf_enable="yes"
service pf restart


curl -o /tmp/pkglist.json  https://raw.githubusercontent.com/utropicmedia/storj-freenas/master/pkg-list.json
iocage create -r 11.2-RELEASE -p /tmp/pkglist.json -n storagenode allow_raw_sockets=1 defaultrouter="192.168.1.1" resolver="nameserver 192.168.1.1; nameserver 8.8.8.8"  ip4_addr="lo${lanid}|192.168.0.${lanid}/24"

curl -o /tmp/Storjstoragenode.json https://raw.githubusercontent.com/utropicmedia/storj-freenas/master/Storjstoragenode.json
iocage fetch -P -n /tmp/Storjstoragenode.json --branch 'master' 

iocage exec storagenode git clone https://raw.githubusercontent.com/utropicmedia/storj-freenas.git storj
iocage exec storagenode bash /root/storj/post_install.sh standard


