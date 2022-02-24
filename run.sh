#!/bin/bash

TARGET=$1
BUILDDIR=/mnt/project/build
DOWNLOADS=/mnt/project/downloads
export LANG=en_US.UTF-8

cd /mnt/project/openbmc
source setup $TARGET $BUILDDIR
if ! grep -q "DL_DIR ? =" conf/local.conf; then
	echo 'DL_DIR ?= "'$DOWNLOADS'"' >> conf/local.conf
fi
bitbake obmc-phosphor-image
