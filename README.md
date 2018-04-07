# Kickstart Server Docker Image CentOS 7

A Docker image which allows you to run salt-master service.

    docker run -d                                \
        -v /tmp/dnsmasq.d:/etc/dnsmasq.d         \
        -v /tmp/pub:/var/ftp/pub                 \
        -v /tmp/tftpboot:/var/lib/tftpboot/pxelinux.cfg       \
        --name kickstart-server                  \
        cmconner156/kickstart-server

## Ports

The following ports are exposed:
 * `21`
 * `53`
 * `67`
 * `69`
 * `4011`

