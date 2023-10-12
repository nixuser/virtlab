
#!/bin/bash

echo Install PXE server
yum -y install epel-release
/usr/bin/crb enable
yum -y install dhcp-server
yum -y install tftp-server
yum -y install nfs-utils
firewall-cmd --add-service=tftp
# disable selinux or permissive
setenforce 0
# 

version=9.2
install=/mnt/install 

cat >/etc/dhcp/dhcpd.conf <<EOF
option space pxelinux;
option pxelinux.magic code 208 = string;
option pxelinux.configfile code 209 = text;
option pxelinux.pathprefix code 210 = text;
option pxelinux.reboottime code 211 = unsigned integer 32;
option architecture-type code 93 = unsigned integer 16;

subnet 10.0.0.0 netmask 255.255.255.0 {
	#option routers 10.0.0.254;
	range 10.0.0.100 10.0.0.120;

	class "pxeclients" {
	  match if substring (option vendor-class-identifier, 0, 9) = "PXEClient";
	  next-server 10.0.0.20;

	  if option architecture-type = 00:07 {
	    filename "uefi/shim.efi";
	    } else {
	    filename "pxelinux/pxelinux.0";
	  }
	}
}
EOF
systemctl start dhcpd
systemctl enable dhcpd

systemctl start tftp.service
systemctl enable tftp.service
yum -y install syslinux-tftpboot.noarch
mkdir /var/lib/tftpboot/pxelinux
cp /tftpboot/pxelinux.0 /var/lib/tftpboot/pxelinux
cp /tftpboot/libutil.c32 /var/lib/tftpboot/pxelinux
cp /tftpboot/menu.c32 /var/lib/tftpboot/pxelinux
cp /tftpboot/libmenu.c32 /var/lib/tftpboot/pxelinux
cp /tftpboot/ldlinux.c32 /var/lib/tftpboot/pxelinux
cp /tftpboot/vesamenu.c32 /var/lib/tftpboot/pxelinux

mkdir /var/lib/tftpboot/pxelinux/pxelinux.cfg

cat >/var/lib/tftpboot/pxelinux/pxelinux.cfg/default <<EOF
default menu
prompt 0
timeout 600

MENU TITLE Demo PXE setup

LABEL linux
  menu label ^Install system
  menu default
  kernel images/vmlinuz
  initrd images/initrd.img 
  append ip=enp0s3:dhcp inst.repo=nfs:10.0.0.20:${install}
LABEL linux-auto
  menu label ^Auto install system
  kernel images/vmlinuz
  initrd images/initrd.img 
  append ip=enp0s3:dhcp inst.ks=nfs:10.0.0.20:/home/vagrant/cfg/ks.cfg inst.repo=nfs:10.0.0.20:${install}
LABEL vesa
  menu label Install system with ^basic video driver
  kernel images/vmlinuz
  append initrd=images/initrd.img ip=dhcp inst.xdriver=vesa nomodeset
LABEL rescue
  menu label ^Rescue installed system
  kernel images/vmlinuz
  append initrd=images/initrd.img rescue
LABEL local
  menu label Boot from ^local drive
  localboot 0xffff
EOF


# Enable UEFI boot
mkdir /var/lib/tftpboot/uefi
cp /boot/efi/EFI/almalinux/grubx64.efi /var/lib/tftpboot/uefi/
cp /boot/efi/EFI/almalinux/shim.efi /var/lib/tftpboot/uefi/
cp /vagrant/grub.cfg /var/lib/tftpboot/uefi/
chmod -R a+r /var/lib/tftpboot/uefi

# Setup NFS auto install
# 

# create exptra space because ISO does not fit to VM rootfs
#mkfs.xfs /dev/sdb
extraspace=/mnt/extraspace/
mkdir $extraspace
#mount /dev/sdb $extraspace

chown vagrant.vagrant  $extraspace
# download ISO image and share it via NFS
url=https://mirror.yandex.ru/almalinux/9.2/isos/x86_64/AlmaLinux-9.2-x86_64-dvd.iso
iso_file=$(basename $url)
# ( cd /mnt/extraspace; curl -O $url )
ln -s /vagrant/$iso_file $extraspace

# or copy disk from local system with
# vagrant ssh-config > config
# scp -o Ciphers=aes128-gcm@openssh.com -F config ../CentOS-8.4.2105-x86_64-dvd1.iso pxeserver:/mnt/extraspace/
mkdir $install
mount -t iso9660  /mnt/extraspace/$iso_file $install
echo "$install *(ro)" > /etc/exports

# copy images from mounted ISO
mkdir -p /var/lib/tftpboot/pxelinux/images/
cp /mnt/install/images/pxeboot/{vmlinuz,initrd.img} /var/lib/tftpboot/pxelinux/images/

mkdir /home/vagrant/cfg
cp /vagrant/anaconda-ks.cfg /home/vagrant/cfg/ks.cfg
chown -R vagrant.vagrant /home/vagrant/cfg
echo '/home/vagrant/cfg *(ro)' >> /etc/exports
systemctl start nfs-server.service
systemctl enable nfs-server.service
