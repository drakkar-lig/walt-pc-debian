FROM debian:stretch

RUN apt-get update && apt-get install -y linux-image-amd64 systemd-sysv openssh-server busybox-static locales netcat-openbsd lldpd

# Unreleased klibc that fixes a bug where ipconfig does not work properly
# with multiple interfaces (Debian bug #852480)
ADD klibc-utils_2.0.4-10_amd64.deb libklibc_2.0.4-10_amd64.deb /tmp/
RUN dpkg -i /tmp/klibc-utils_2.0.4-10_amd64.deb /tmp/libklibc_2.0.4-10_amd64.deb
RUN rm /tmp/*klibc*.deb
RUN update-initramfs -u

# Install kernel and initrd
RUN mkdir -p /pc-x86-64-initrd/
RUN touch /pc-x86-64-initrd/no-dtb
# This always points to the latest kernel version
RUN cp /vmlinuz /pc-x86-64-initrd/kernel
RUN cp /initrd.img /pc-x86-64-initrd/initrd

# Configure locale
RUN echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen
RUN echo 'fr_FR.UTF-8 UTF-8' >> /etc/locale.gen
RUN locale-gen

# Script to notify the server that the image has booted
ADD walt-notify-bootup.service /etc/systemd/system/walt-notify-bootup.service
RUN ln -s /etc/systemd/system/walt-notify-bootup.service /etc/systemd/system/multi-user.target.wants/walt-notify-bootup.service

# Allow passwordless root login on the serial console
RUN sed -i -e 's#^root:[^:]*:#root::#' /etc/shadow
