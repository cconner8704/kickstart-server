FROM cmconner156/docker-centos7-systemd
MAINTAINER Chris Conner <chrism.conner@gmail.com>

#https://hub.docker.com/_/centos/
#https://www.tecmint.com/install-pxe-network-boot-server-in-centos-7/
#https://www.linuxtechi.com/configure-pxe-installation-server-centos-7/
#https://hostpresto.com/community/tutorials/how-to-install-and-configure-cobbler-on-centos-7/
RUN set -ex                           \
    && yum install -y epel-release \
    && yum update -y \
    && yum install -y python-pip \
    && yum install -y net-tools \
    && yum install -y iproute \
    && yum install -y dnsmasq \
    && yum install -y syslinux \
    && yum install -y tftp-server \
    && yum install -y tftp \
    && yum install -y xinetd \
    && yum install -y vsftpd \
    && yum install -y httpd \
    && yum install -y cobbler \
    && yum install -y cobbler-web \
    && yum install -y pykickstart \
    && yum clean -y expire-cache

# volumes
#VOLUME /etc/dnsmasq.d         \
#       /var/ftp/pub	      \
#       /var/www/html	      \
VOLUME /var/lib/tftpboot      \      
       /etc/cobbler           \
       /var/lib/cobbler       \
       /var/www/cobbler       \
       /var/named             \
       /sys/fs/cgroup         

# ports #tcp for all except 69 and 4011 are UDP
EXPOSE 21 53 67 69 80 4011

#Extra Config
#RUN /bin/cp -fr /usr/share/syslinux/* /var/lib/tftpboot
RUN sed -i "s/disable.*=.*yes/disable                 = no/g" /etc/xinetd.d/tftp


# add run file
ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# entrypoint
CMD ["/entrypoint.sh"]
