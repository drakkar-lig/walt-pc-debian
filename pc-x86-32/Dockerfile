# Builder image
# -------------
FROM debian:buster as builder

# run debootstrap
ADD run-debootstrap.sh /root
RUN /root/run-debootstrap.sh

# build modified initramfs packages
ADD build-initramfs.sh /root
RUN /root/build-initramfs.sh

# Target image
# ------------
FROM scratch

# specify which node models this image can handle
# note: since this is a 32-bit OS, we support both 32-bit and 64-bit nodes
LABEL walt.node.models=pc-x86-32,pc-x86-64

# specify min walt server version needed
LABEL walt.server.minversion=4

# Copy the subdirectory generated from debootstrap first stage
WORKDIR /
COPY --from=builder /root/fs .

# prepare and run 1st customization
COPY customize1 /
COPY --from=builder /root/*.deb /root/
RUN /root/customize1.sh pc-x86-32

# install an older static version of busybox for compatibility with
# node init scripts distributed with older walt server version
# (if installing busybox-static package instead, we would have
# to set LABEL walt.server.minversion to 5)
COPY --from=waltplatform/pc-x86-32-debian:stretch /bin/busybox /bin

# prepare and run 2nd customization
COPY customize2 /
RUN /root/customize2.sh pc-x86-32
