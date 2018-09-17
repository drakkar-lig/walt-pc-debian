FROM debian:stretch

# specify which node models this image can handle
LABEL walt.node.models=pc-x86-64

# Base packages that are really needed for Walt to work correctly.
RUN apt-get update && apt-get install -y linux-image-amd64 systemd-sysv openssh-server busybox-static locales netcat-openbsd lldpd \
 && rm -rf /var/lib/apt/lists/* \
 && rm -rf /var/cache/apt/*

# Unreleased klibc that fixes a bug where ipconfig does not work properly
# with multiple interfaces (Debian bug #852480)
ADD klibc-utils_2.0.4-10_amd64.deb libklibc_2.0.4-10_amd64.deb /tmp/
RUN dpkg -i /tmp/klibc-utils_2.0.4-10_amd64.deb /tmp/libklibc_2.0.4-10_amd64.deb && rm -f /tmp/*klibc*.deb
RUN update-initramfs -u

# Install kernel and initrd.
# /vmlinuz and /initrd.img always point to the latest kernel version.
RUN mkdir -p /pc-x86-64/ && touch /pc-x86-64/no-dtb && ln -s ../vmlinuz /pc-x86-64/kernel && ln -s ../initrd.img /pc-x86-64/initrd

# Install custom ipxe scripts
COPY ipxe/ /pc-x86-64/

# Configure locale
RUN echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen && echo 'fr_FR.UTF-8 UTF-8' >> /etc/locale.gen
RUN locale-gen

# Allow passwordless root login on the serial console
RUN sed -i -e 's#^root:[^:]*:#root::#' /etc/shadow

# Additional packages
RUN apt-get update && apt-get install -y vim \
 && rm -rf /var/lib/apt/lists/* \
 && rm -rf /var/cache/apt/*
