FROM cmconner156/docker-centos7-systemd
MAINTAINER Chris Conner <chrism.conner@gmail.com>

#https://hub.docker.com/_/centos/
#https://www.tecmint.com/install-pxe-network-boot-server-in-centos-7/
#https://www.linuxtechi.com/configure-pxe-installation-server-centos-7/
#https://hostpresto.com/community/tutorials/how-to-install-and-configure-cobbler-on-centos-7/
RUN set -ex                           \
    && yum install -y epel-release \
    && yum update -y \
    && yum install epel-release -y \
    && yum update -y \
    && yum install -y https://repo.saltstack.com/yum/redhat/salt-repo-latest-2.el7.noarch.rpm \
    && yum install -y salt-cloud \
    && yum install -y python-pip \
    && /usr/bin/pip install pyvmomi \
    && yum install -y net-tools \
    && yum install -y iproute \
    && yum install -y vim \
    && yum install -y dnsmasq \
    && yum install -y syslinux \
    && yum install -y tftp-server \
    && yum install -y tftp \
    && yum install -y xinetd \
    && yum install -y dhcp \
    && yum install -y dhcp-common \
    && yum install -y bind \
    && yum install -y vsftpd \
    && yum install -y httpd \
    && yum install -y cobbler \
    && yum install -y cobbler-web \
    && yum install -y pykickstart \
    && yum install -y debmirror \
    && yum install -y vim \
    && yum install -y less \
    && yum clean -y expire-cache

# volumes
#VOLUME /etc/dnsmasq.d         \
#       /var/ftp/pub	      \
#       /var/www/html	      \
#       /var/named             \ 
VOLUME /var/lib/tftpboot      \      
       /etc/cobbler           \
       /var/lib/cobbler       \
       /var/www/cobbler       \
       /etc/salt/cloud.maps.d \
       /etc/salt/cloud.profiles.d \
       /etc/salt/cloud.providers.d \
       /run                   \
       /mnt                   \
       /sys/fs/cgroup

# ports #tcp for all except 69 and 547 are UDP
#EXPOSE 69/udp 69/tcp 80/tcp 443/tcp 547/udp 547/tcp 25150/tcp 25151/tcp
EXPOSE 67/udp 67/tcp 69/udp 69/tcp 80/tcp 443/tcp 25150/tcp 25151/tcp

#Extra Config
#Enable tftp
RUN sed -i "s/disable.*=.*yes/disable                 = no/g" /etc/xinetd.d/tftp

#Add cobbler sync systemd
RUN echo -e '[Unit]\n               \
Description=Run cobbler get-loaders\n      \
After=cobbler.service\n        \
Requires=cobbler.service\n          \
\n                                  \
[Service]\n                         \
WorkingDirectory=/etc/cobbler\n     \
Type=oneshot\n                      \
RemainAfterExit=no\n                \
ExecStart=/usr/bin/cobbler get-loaders\n \
ExecReload=/usr/bin/cobbler get-loaders\n \
\n                                  \
[Install]\n                         \
WantedBy=multi-user.target\n        \
'                                   \
>> /etc/systemd/system/cobblergetloaders.service

#Add cobbler check systemd
RUN echo -e '[Unit]\n               \
Description=Run cobbler check\n     \
After=cobblergetloaders.service\n   \
Requires=cobbler.service\n \
\n                                  \
[Service]\n                         \
WorkingDirectory=/etc/cobbler\n     \
Type=oneshot\n                      \
RemainAfterExit=no\n                \
ExecStart=/usr/bin/cobbler check\n  \
ExecReload=/usr/bin/cobbler check\n \
\n                                  \
[Install]\n                         \
WantedBy=multi-user.target\n        \
'                                   \
>> /etc/systemd/system/cobblercheck.service

#Add cobbler sync systemd
RUN echo -e '[Unit]\n               \
Description=Run cobbler sync\n      \
After=cobblercheck.service\n        \
Requires=cobbler.service\n          \
\n                                  \
[Service]\n                         \
WorkingDirectory=/etc/cobbler\n     \
Type=oneshot\n                      \
RemainAfterExit=no\n                \
ExecStart=/usr/bin/cobbler sync\n   \
ExecReload=/usr/bin/cobbler sync\n  \
\n                                  \
[Install]\n                         \
WantedBy=multi-user.target\n        \
'                                   \
>> /etc/systemd/system/cobblersync.service

#RUN systemctl enable dnsmasq.service
#RUN systemctl enable vsftpd.service
#RUN systemctl enable xinetd.service
RUN systemctl enable rsyncd.service
RUN systemctl enable httpd.service
RUN systemctl enable dhcpd.service
RUN systemctl enable cobblerd.service
RUN systemctl enable cobblergetloaders.service
RUN systemctl enable cobblercheck.service
RUN systemctl enable cobblersync.service
RUN touch /etc/xinetd.d/rsync

#systemctl start dnsmasq
#systemctl start vsftpd
#systemctl start httpd
#systemctl start xinetd
#systemctl start cobblerd.service
#systemctl start cobblercheck.service
#systemctl start cobblersync.service

# add run file
#ADD entrypoint.sh /entrypoint.sh
#RUN chmod +x /entrypoint.sh

# entrypoint
CMD ["/usr/sbin/init"]
