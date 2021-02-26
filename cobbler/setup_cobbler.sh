#!/bin/bash


# workaround with DNS server
echo 'nameserver 8.8.8.8 > /etc/resolv.conf'
echo Install cobbler
yum -y install epel-release
yum -y install cobbler

# disable selinux or permissive
setenforce 0

systemctl enable cobblerd
systemctl start cobblerd
systemctl enable httpd 
systemctl start httpd

# cobbler utilities 
yum -y install yum-utils  pykickstart debmirror
cobbler get-loaders
# for managed dhcp server
yum -y install dhcp bind fence-agents tftp-server tftp
# web interface
yum -y install cobbler-web

#  enable and start rsyncd.service with systemctl
systemctl enable rsyncd.service
systemctl start  rsyncd.service


# sed 's/next_server: 127.0.0.1/next_server: 192.168.1.10/' /etc/cobbler/settings
# sed 's/^server: 127.0.0.1/server: 192.168.1.10/' /etc/cobbler/settings
# sed 's/^manage_dhcp: 0/manage_dhcp: 1/' /etc/cobbler/settings
# sed '/disable/ s/yes/no/' /etc/xinetd.d/tftp
# sed 's/^@dists/# @dists/' /etc/debmirror.conf
# sed 's/^@arches/# @arches/' /etc/debmirror.conf
