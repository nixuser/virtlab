# example and template for Alpine Linux ISO installation 
# as guest VM for Xen


# check and update latest version
# on page https://alpinelinux.org/downloads/ virtual images
ver=3.18
minor=.4

url=https://dl-cdn.alpinelinux.org/alpine/v${ver}/releases/x86_64/alpine-virt-${ver}${minor}-x86_64.iso


mkdir /data
cd /data
wget "$url"
mkdir /media/cdrom
iso_name=$(basename $url)
mount -t iso9660 -o loop $iso_name /media/cdrom
dd if=/dev/zero of=/data/a1.img bs=1M count=3000

cat >/etc/xen/a1.cfg <<EOF
# Alpine Linux PV DomU
# Kernel paths for install
kernel = "/media/cdrom/boot/vmlinuz-virt"
ramdisk = "/media/cdrom/boot/initramfs-virt"
extra="modules=loop,squashfs console=hvc0"

# Path to HDD and iso file

disk = [
        'format=raw, vdev=xvda, access=w, target=/data/a1.img',
        'format=raw, vdev=xvdc, access=r, devtype=cdrom, target=/data/${iso_name}'
        ]

# Network configuration

vif = ['bridge=xenbr0']


# DomU settings
memory = 512
name = "alpine-a1"
vcpus = 1
maxvcpus = 1
EOF

