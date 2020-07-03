FROM debian:buster

# specify which node models this image can handle
LABEL walt.node.models=pc-x86-64

# specify min walt server version needed
LABEL walt.server.minversion=4

# Install packages
RUN apt-get update && \
    apt-get install -y linux-image-amd64 systemd-sysv openssh-server \
    locales netcat-openbsd lldpd vim \
 && rm -rf /var/lib/apt/lists/* \
 && rm -rf /var/cache/apt/*

# install an older static version of busybox for compatibility with
# node init scripts distributed with older walt server version
# (if installing busybox-static package instead, we would have
# to set LABEL walt.server.minversion to 5)
COPY --from=waltplatform/pc-x86-64-debian:stretch /bin/busybox /bin

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
