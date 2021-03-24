#!/bin/bash

apt-get update
apt-get install -y debootstrap

cd /root
debootstrap --foreign --no-check-gpg --variant minbase --arch i386 buster fs
# apparently this newer version of debootstrap creates a symlink
# /root/fs/proc -> /proc
if [ -L /root/fs/proc ]
then
    rm /root/fs/proc
    mkdir /root/fs/proc
fi
