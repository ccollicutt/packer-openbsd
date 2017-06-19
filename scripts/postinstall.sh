#!/bin/sh

set -e

uname_r=`uname -r`

export PKG_PATH="$MIRROR/pub/OpenBSD/$uname_r/packages/`arch -s`/"

echo "INFO: Adding PKG_PATH to /root/.profile"
echo "export PKG_PATH=\"$PKG_PATH\"" >> /root/.profile

echo "INFO: Adding curl"
pkg_add curl-7.53.1

echo "INFO: configuring hostname.vio0"
rm /etc/hostname.*
echo "dhcp" >> /etc/hostname.vio0

#echo "INFO: Adding cloud-init.pl"
#ftp -o /usr/local/libdata/cloud-init.pl https://raw.githubusercontent.com/exoscale/openbsd-cloud-init/master/cloud-init.pl
#perl /usr/local/libdata/cloud-init.pl deploy
