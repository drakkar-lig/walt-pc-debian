FROM debian:stretch

# specify which node models this image can handle
LABEL walt.node.models=pc-x86-64

# Install packages
RUN apt-get update && \
    apt-get install -y linux-image-amd64 systemd-sysv openssh-server \
    busybox-static locales netcat-openbsd lldpd vim \
 && rm -rf /var/lib/apt/lists/* \
 && rm -rf /var/cache/apt/*

# Unreleased klibc that fixes a bug where ipconfig does not work properly
# with multiple interfaces (Debian bug #852480)
ADD klibc-utils_2.0.4-10_amd64.deb libklibc_2.0.4-10_amd64.deb /tmp/
RUN dpkg -i /tmp/klibc-utils_2.0.4-10_amd64.deb /tmp/libklibc_2.0.4-10_amd64.deb && \
    rm -f /tmp/*klibc*.deb && update-initramfs -u

# Install custom ipxe boot scripts
COPY boot/ /boot

# Install image spec file
COPY image.spec /etc/walt/

# Configure locale
RUN echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen && \
    echo 'fr_FR.UTF-8 UTF-8' >> /etc/locale.gen && \
    locale-gen

# Allow passwordless root login on the serial console
RUN sed -i -e 's#^root:[^:]*:#root::#' /etc/shadow
