#!/bin/bash

yum install -y yum-utils

sudo yum -y install https://zfsonlinux.org/epel/zfs-release.el8_4.noarch.rpm 
source /etc/os-release
dnf install https://zfsonlinux.org/epel/zfs-release.el${VERSION_ID/./_}.noarch.rpm
rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-zfsonlinux

dnf config-manager --disable zfs
dnf config-manager --enable zfs-kmod
dnf install -y zfs
#modprobe zfs



