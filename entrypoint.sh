#!/bin/sh

/bin/cp -fr /usr/share/syslinux/* /var/lib/tftpboot

while [ 1 ]
do
  sleep 1000
done

systemctl start dnsmasq
systemctl start vsftpd
systemctl start httpd
systemctl start xinetd
systemctl start cobblerd
