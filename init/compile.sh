#!/bin/bash
#
#(C) Sergey Sergeev aka adron, 2019-2021
#

. ../globals.sh

GCC_ARGS="-static"
#for 7.0rc1 we need gcc with soft-float ONLY!
#apt-get install gcc-arm-linux-gnueabi
#[ ${TARGET_ARCH} = "arm" ] && {
#	GCC=arm-linux-gnueabi-gcc
#	OBJCOPY=arm-linux-gnueabi-objcopy
#}

[ ${TARGET_ARCH} = "aarch64" ] && {
	GCC=arm-linux-gnueabihf-gcc
	OBJCOPY=arm-linux-gnueabihf-objcopy
#	GCC_ARGS="$GCC_ARGS -mfloat-abi=soft"
}

CPIO_FS="../cpio-fs-${TARGET_ARCH}"

#$GCC $GCC_ARGS ./test.c -o ./test
#$OBJCOPY --strip-all ./test ./test
#exit 0

$GCC $GCC_ARGS ./init.c -o ${CPIO_FS}/init
$OBJCOPY --strip-all ${CPIO_FS}/init ${CPIO_FS}/init

exit 0

cd ../
./pack-kernel.sh
#./ftp_upload.sh
