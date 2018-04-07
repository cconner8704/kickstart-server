#!/bin/sh
while [ 1 ]
do
  sleep 1000
done

/bin/cp -fr /usr/share/syslinux/* /var/lib/tftpboot
systemctl start dnsmasq
systemctl start vsftpd
