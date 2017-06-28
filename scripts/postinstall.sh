#!/bin/sh

set -e

uname_r=`uname -r`

export PKG_PATH="$MIRROR/pub/OpenBSD/$uname_r/packages/`arch -s`/"

echo "INFO: Adding PKG_PATH to /root/.profile"
echo "export PKG_PATH=\"$PKG_PATH\"" >> /root/.profile

# NOTE(curtis): Could use ftp command instead of installing curl if desired
echo "INFO: Adding curl"
pkg_add curl-7.53.1

echo "INFO: configuring hostname.vio0"
rm /etc/hostname.*
echo "dhcp" >> /etc/hostname.vio0

#
# Cleanup
#

echo "INFO: Removing various files..."
rm /etc/ssh/ssh_host*
rm /etc/random.seed
rm /var/db/host.random
rm /etc/isakmpd/private/local.key
rm /etc/isakmpd/local.pub
rm /etc/iked/private/local.key
#rm /etc/isakmpd/local.pub
rm -rf /tmp/*
rm /var/db/dhclient.leases.vio0

echo "INFO: Disabling root password"
chpass -a 'root:*:0:0:daemon:0:0:Charlie &:/root:/bin/ksh'

echo "INFO: Adding /etc/rc.firsttime with basic metadata gathering"

# If you quote EOF then it won't evaluate backticks, which end up being empty
# after an echo.
cat << "EOF" > /etc/rc.firsttime
#!/bin/sh
META="http://169.254.169.254/latest/meta-data"
C="/usr/local/bin/curl -s"

i="1"
# Test if we can hit the metadata URI
while [ $i -lt 20 ]; do
  echo "INFO: Attempt $i to curl metadata URI"
  $C $META > /dev/null && break
  i=`expr $i + 1`
  sleep 2
done
echo "INFO: Was able to curl metadata"

echo "INFO: Curling local-hostname"
MYNAME=`$C $META/local-hostname | cut -f 1 -d "."`
if [ -z "$MYNAME " ]; then
  echo "ERROR: MYNAME is empty"
else
  echo "INFO: Adding hostname to /etc/myname"
  echo $MYNAME > /etc/myname
fi
echo "INFO: Curling public-key"
SSH_KEY=`$C $META/public-keys/0/openssh-key`
if [ -z "$SSH_KEY" ]; then
  echo "ERROR: SSH_KEY is empty"
else
  echo "INFO: adding ssh key to /root/.ssh/authorized_keys"
  echo "$SSH_KEY" > /root/.ssh/authorized_keys
  chmod 600 /root/.ssh/authorized_keys
fi
EOF
