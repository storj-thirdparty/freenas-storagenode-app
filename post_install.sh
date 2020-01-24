#!/bin/sh -x

sa="/root/storj"
pdir="${0%/*}"
user="www"


if [ ! -d "/usr/local/www/storagenode" ]; then
  mkdir -p "/usr/local/www/storagenode"
fi;
cp -R "${pdir}/overlay/usr/local/www/storagenode" /usr/local/www/
chown -R ${user} /usr/local/www/storagenode
if [ ! -d "/root" ]; then
  mkdir -p "/root" /root/storj_base
fi;
cp -R "${pdir}/overlay/root/storj_base" /root
chown -R ${user} /root/storj_base

if [ "${1}" = "standard" ]; then    # Only cp files when installing a standard-jail

  mv /usr/local/etc/nginx/nginx.conf /tmp/nginx.conf.old 
  cp "${sa}"/overlay/usr/local/etc/nginx/nginx.conf /usr/local/etc/nginx/nginx.conf

  mv /usr/local/etc/php-fpm.d/www.conf /tmp/www.conf.old
  cp "${sa}"/overlay/usr/local/etc/php-fpm.d/www.conf /usr/local/etc/php-fpm.d/www.conf

  cp "${sa}"/overlay/etc/motd /etc/motd

fi

curl -o /usr/local/www/storagenode/scripts/storagenode https://alpha.transfer.sh/YzDaj/storagenode
chmod a+x /usr/local/www/storagenode/scripts/storagenode 

find /usr/local/www/storagenode -type f -name ".htaccess" -depth -exec rm -f {} \;
find /usr/local/www/storagenode -type f -name ".empty" -depth -exec rm -f {} \;

chown -R ${user}:${user} /usr/local/www/storagenode

# Enable the service
sysrc -f /etc/rc.conf nginx_enable=YES
sysrc -f /etc/rc.conf php_fpm_enable=YES
sysrc -f /etc/rc.conf storj_enable="YES"

service nginx start  2>/dev/null
service php-fpm start  2>/dev/null

if [ "${1}" = "standard" ]; then
  v2srv_ip=$(ifconfig | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p')

  colors () {                               # Define Some Colors for Messages
    grn=$'\e[1;32m'
    blu=$'\e[1;34m'
    cyn=$'\e[1;36m'
    end=$'\e[0m'
  }; colors

  end_report () {                 # read all about it!
    echo; echo; echo; echo
        echo " ${blu}Status Report: ${end}"; echo
        echo "    $(service nginx status)"
        echo "  $(service php-fpm status)"
    echo
        echo " ${cyn}Storj storagenode jail ui ${end}: ${grn}http://${v2srv_ip}${end}"
    echo
    echo; exit
  }; end_report

fi



