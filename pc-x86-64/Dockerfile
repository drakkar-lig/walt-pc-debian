# Builder image
# -------------

FROM debian:buster as builder

ADD build-initramfs.sh /root
RUN /root/build-initramfs.sh

# Target image
# ------------

FROM debian:buster

# specify which node models this image can handle
LABEL walt.node.models=pc-x86-64

# specify min walt server version needed
LABEL walt.server.minversion=4

# prepare and run 1st customization
COPY customize1 /
COPY --from=builder /root/*.deb /root/
RUN /root/customize1.sh pc-x86-64

# install an older static version of busybox for compatibility with
# node init scripts distributed with older walt server version
# (if installing busybox-static package instead, we would have
# to set LABEL walt.server.minversion to 5)
COPY --from=waltplatform/pc-x86-64-debian:stretch /bin/busybox /bin

# prepare and run 2nd customization
COPY customize2 /
RUN /root/customize2.sh pc-x86-64
