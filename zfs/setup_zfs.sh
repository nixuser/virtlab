#!/bin/bash

dnf install -y https://zfsonlinux.org/epel/zfs-release-2-2$(rpm --eval "%{dist}").noarch.rpm 
dnf config-manager --disable zfs
dnf config-manager --enable zfs-kmod
dnf install -y zfs

#modprobe zfs



