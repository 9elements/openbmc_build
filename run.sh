#!/bin/bash

TARGET=$1
BUILDDIR=/mnt/project/build
DOWNLOADS=/mnt/project/downloads
export LANG=en_US.UTF-8

# Allow SSH connections to github.com
mkdir -p ~/.ssh/
ssh-keyscan github.com >> ~/.ssh/known_hosts

cd /mnt/project/openbmc
source setup $TARGET $BUILDDIR
touch conf/sanity.conf
if ! grep -q "DL_DIR ? =" conf/local.conf; then
	echo 'DL_DIR ?= "'$DOWNLOADS'"' >> conf/local.conf
fi
bitbake obmc-phosphor-image
