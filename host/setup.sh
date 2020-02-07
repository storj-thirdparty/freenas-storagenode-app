#!/bin/bash

lanid=3
ifconfig lo${lanid} create inet 192.168.0.${lanid} netmask 255.255.255.0

#TODO : Add update pf.conf file for packet filter settings (NAT & listening ports !)
cat >> /etc/rc.sys <<NWIF_DEF
ipv6_network_interfaces="none"
ifconfig_lo${lanid}="inet 192.168.0.${lanid} netmask 255.255.255.0"
NWIF_DEF
service netif restart

ifconfig lo${lanid} alias 192.168.0.${lanid} netmask 0xFFFFFFFF

cat >> /etc/pf.conf <<PF_CONF_ADDON
# -----------------------------------------------------------
#  Added for Storj Admin Jails NW config
# -----------------------------------------------------------
ext_if="em0"
storagenodejail="192.168.0.${lanid}"

#Redirect web traffic for stoj admin to the jail.
extwebport=8088
extsshport=2222
extsnsport=14002
intwebport=80
intsshport=22
intsnsport=14002

nat on \$ext_if from \$storagenodejail to any -> (\$ext_if)

rdr on \$ext_if proto tcp from any to (\$ext_if) port \$extwebport -> \$storagenodejail port \$intwebport
rdr on \$ext_if proto tcp from any to (\$ext_if) port \$extsshport -> \$storagenodejail port \$intsshport
rdr on \$ext_if proto tcp from any to (\$ext_if) port \$extsnsport -> \$storagenodejail port \$intsnsport

pass in on \$ext_if proto tcp to \$storagenodejail port { http, https } keep state

# -----------------------------------------------------------
PF_CONF_ADDON
sysrc pf_enable="yes"
service pf restart


# --------------------------------------------------------------------------------------
# Setup the plugin
# --------------------------------------------------------------------------------------
curl -o /tmp/Storjstoragenode.json https://raw.githubusercontent.com/utropicmedia/storj-freenas/master/Storjstoragenode.json
iocage fetch -P -r 11.2-RELEASE -n /tmp/Storjstoragenode.json allow_raw_sockets=1 defaultrouter="192.168.1.1" resolver="nameserver 192.168.1.1; nameserver 8.8.8.8"  ip4_addr="lo${lanid}|192.168.0.${lanid}/24"

