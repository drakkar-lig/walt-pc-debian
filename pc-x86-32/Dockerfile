FROM debian:buster as builder
RUN apt-get update && apt-get install -y debootstrap && apt-get clean
WORKDIR /root
RUN debootstrap --foreign --no-check-gpg --variant minbase --arch i386 \
                buster fs
# apparently this newer version of debootstrap creates a symlink
# /root/fs/proc -> /proc
RUN [ -L /root/fs/proc ] && rm /root/fs/proc && mkdir /root/fs/proc

# layered image: build on this base debian directory
# --------------------------------------------------
FROM scratch
WORKDIR /
# Copy the subdirectory generated from debootstrap first stage
COPY --from=builder /root/fs .
RUN /debootstrap/debootstrap --second-stage

# specify which node models this image can handle
# note: since this is a 32-bit OS, we support both 32-bit and 64-bit nodes
LABEL walt.node.models=pc-x86-32,pc-x86-64

# specify min walt server version needed
LABEL walt.server.minversion=4

# Install packages
RUN apt update && \
    apt install -y linux-image-686-pae systemd-sysv openssh-server \
        locales netcat-openbsd lldpd vim \
 && rm -rf /var/lib/apt/lists/* \
 && rm -rf /var/cache/apt/*

# install an older static version of busybox for compatibility with
# node init scripts distributed with older walt server version
# (if installing busybox-static package instead, we would have
# to set LABEL walt.server.minversion to 5)
COPY --from=waltplatform/pc-x86-32-debian:stretch /bin/busybox /bin

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
