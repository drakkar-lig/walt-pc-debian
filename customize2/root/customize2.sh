#!/bin/bash

model="$1"

if [ "$model" = "pc-x86-64" ]
then
    # This is a 64-bit OS, we do not support 32-bit nodes here
    rm -rf /boot/pc-x86-32
fi

# Configure locale
echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen
echo 'fr_FR.UTF-8 UTF-8' >> /etc/locale.gen
locale-gen

# Allow passwordless root login on the serial console
sed -i -e 's#^root:[^:]*:#root::#' /etc/shadow

# enable service to save uptime in /run when ready
systemctl enable uptime-ready

# cleanup
rm -f /root/customize2.sh
