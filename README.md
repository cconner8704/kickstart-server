# Kickstart Server Docker Image CentOS 7

A Docker image which allows you to run kickstart service using cobbler.

This image uses systemd, so you must include cgroup and elevated privs.

#Only if /sys/fw/cgroup/systemd exists, not the case on Unraid
-v /sys/fs/cgroup:/sys/fs/cgroup:ro      \

On ubuntu you need to add:

-v /tmp/$(mktemp -d):/run

Always need:

--cap-add SYS_ADMIN --security-opt seccomp:unconfined

Example Start

    docker run -d --cap-add SYS_ADMIN --security-opt seccomp:unconfined \
        -v /tmp/tftpboot:/var/lib/tftpboot       \
        -v /tmp/named:/var/named                 \
        -v /tmp/cobbler/etc:/etc/cobbler         \
        -v /tmp/cobbler/lib:/var/lib/cobbler     \
        -v /tmp/cobbler/www:/var/www/cobbler     \
        -v /sys/fs/cgroup:/sys/fs/cgroup:ro      \
        -v /tmp/$(mktemp -d):/run                \
        --name kickstart-server                  \
        cmconner156/kickstart-server

## Ports

The following ports are exposed:
 * `21`
 * `53`
 * `67`
 * `69`
 * `80`
 * `443`
 * `4011`

