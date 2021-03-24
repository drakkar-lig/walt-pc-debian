#!/bin/sh

PACKAGES="systemd-sysv openssh-server \
    locales netcat-openbsd lldpd vim python3-pip kexec-tools"

model="$1"

if [ "$model" = "pc-x86-32" ]
then
    # resume deboostrap process
    /debootstrap/debootstrap --second-stage
    # set linux package
    KERNEL_PACKAGE="linux-image-686-pae"
    # set appropriate nbfs mount binary
    mv /usr/sbin/mount.nbfs.static.i386 /sbin/mount.nbfs.static
else # pc-x86-64
    # set linux package
    KERNEL_PACKAGE="linux-image-amd64"
    # set appropriate nbfs mount binary
    mv /usr/sbin/mount.nbfs.static.amd64 /sbin/mount.nbfs.static
fi

# remove other versions of nbfs mount binary
rm /usr/sbin/mount.nbfs.static.*

install_packages() {
    apt-get update
    DEBIAN_FRONTEND=noninteractive apt-get install -y "$@"
}

# Install packages
install_packages $PACKAGES $KERNEL_PACKAGE

# update initramfs with ability to use nbfs
apt remove -y initramfs-tools initramfs-tools-core
dpkg -i /root/initramfs-tools*.deb
install_packages $KERNEL_PACKAGE    # was removed when removing initramfs-tools

# Install walt python packages
pip3 install /root/*.whl
walt-node-setup

# Enable fast reboots using fake ipxe and kexec
ln -s $(which walt-ipxe-kexec-reboot) /bin/walt-reboot

# cleanup
rm -rf /var/lib/apt/lists/*
rm -rf /var/cache/apt/*
rm -rf /root/*
