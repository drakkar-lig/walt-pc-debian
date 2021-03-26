#!/bin/bash
INITRAMFS_TOOLS_REPO="https://gricad-gitlab.univ-grenoble-alpes.fr/dublee/initramfs-tools"
INITRAMFS_TOOLS_COMMIT="795614cb2a221e2f3011acf9507e33916a3a46a5"
PACKAGES="make gcc dpkg-dev debhelper git bash-completion shellcheck"

# install packages
apt-get update
DEBIAN_FRONTEND=noninteractive apt-get install -y $PACKAGES

# download and build modified initramfs-tools package (mainly to allow nbfs boot)
cd /root
git clone -b nbfs $INITRAMFS_TOOLS_REPO
cd initramfs-tools
git checkout $INITRAMFS_TOOLS_COMMIT
dpkg-buildpackage --no-sign

