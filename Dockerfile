FROM centos:centos7
MAINTAINER Chris Conner <chrism.conner@gmail.com>

#https://www.tecmint.com/install-pxe-network-boot-server-in-centos-7/
RUN set -ex                           \
    && yum install epel-release -y \
    && yum update -y \
    && yum install -y python-pip \
    && yum install -y net-tools \
    && yum install -y iproute \
    && yum install -y dnsmasq \
    && yum install -y syslinux \
    && yum install -y tftp-server \
    && yum install -y vsftpd \
    && yum install -y httpd \
    && yum clean -y expire-cache

# volumes
VOLUME /etc/dnsmasq.d         \
       /var/ftp/pub	      \
       /var/www/html	      \
       /var/lib/tftpboot      \      

# ports #tcp for all except 69 and 4011 are UDP
EXPOSE 21 53 67 69 4011

#Extra Config
#RUN /bin/cp -fr /usr/share/syslinux/* /var/lib/tftpboot

# add run file
ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# entrypoint
CMD /entrypoint.sh
