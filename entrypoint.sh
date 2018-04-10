#!/bin/sh

/bin/cp -fr /usr/share/syslinux/* /var/lib/tftpboot
/usr/sbin/init

while [ 1 ]
do
  sleep 1000
done

systemctl enable dnsmasq
systemctl enable vsftpd
systemctl enable httpd
systemctl enable xinetd
systemctl enable cobblerd

systemctl start dnsmasq
systemctl start vsftpd
systemctl start httpd
systemctl start xinetd
systemctl start cobblerd

/usr/bin/cobbler check
/usr/bin/cobbler sync
