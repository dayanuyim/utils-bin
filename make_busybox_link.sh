#!/bin/bash

dir="$1"

if [ -z "$dir" ]; then
    echo "usage: ${0##*/} <dir>" >&2
    exit 1
fi

cd "$dir" || exit 2

for i in [ [[ arp arping ash blkid brctl cat chmod cp crond cut date dd df dhcprelay dirname dnsdomainname du dumpleases echo ethreg fakeidentd fdisk find flock free getopt grep gzip halt head hostname hush ifconfig inetd init insmod ip ipaddr iplink iproute iptunnel kill killall klogd linuxrc ln logger login logread ls lsmod lsusb md md5sum mdev mkdir mknod mm more mount mv nslookup ping ping6 poweroff ps rdate rdev reboot rm rmmod route sed setserial sh sleep stat sync syslogd tail tar telnetd test tftpd top touch tr tty udhcpc udhcpd umount uname uptime vi wc wget xargs zcip;
do
  echo ln -s busybox "$i";
  ln -s busybox "$i";
done
