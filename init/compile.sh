#!/bin/bash
#
#(C) Sergey Sergeev aka adron, 2019
#

. ../globals.sh

#for 7.0rc1 we need gcc with soft-float ONLY!
#apt-get install gcc-arm-linux-gnueabi
[ ${TARGET_ARCH} = "arm" ] && {
	GCC=arm-linux-gnueabi-gcc
	OBJCOPY=arm-linux-gnueabi-objcopy
}

CPIO_FS="../cpio-fs-${TARGET_ARCH}"

$GCC -static ./init.c -o ${CPIO_FS}/init
$OBJCOPY --strip-all ${CPIO_FS}/init ${CPIO_FS}/init

#exit 0

cd ../
./pack-kernel.sh
#./ftp_upload.sh
