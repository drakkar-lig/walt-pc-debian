#!/bin/busybox sh

cd /boot/common/

# activate: replace target of symlinks
ln -sf start-nbfs-32.ipxe start-32.ipxe
ln -sf start-nbfs-64.ipxe start-64.ipxe
