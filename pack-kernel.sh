#!/bin/sh
#
#(C) Sergey Sergeev aka adron, 2019
#

. ./globals.sh

ROOT=$(pwd)
cd ./cpio-fs-${TARGET_ARCH}
find . 2>/dev/null | cpio --quiet -o --format='newc' | \
	xz --check=crc32 --lzma2=dict=512KiB > ${ROOT}/bins/kernel.p3-new.xz
cd ${ROOT}

cat ./bins/kernel.p2.xz ./bins/kernel.p3-new.xz > ./bins/kernel-new.combo
#cat ./bins/kernel.p2.xz ./bins/kernel.p3.xz > ./bins/kernel-new.combo
${OBJCOPY} --update-section initrd=./bins/kernel-new.combo ./bins/kernel.elf ./bins/kernel-new.elf

#cat ./bins/kernel-new.elf > /var/lib/tftpboot/linux_t1.bin

#now update busybox for current ARCH
BUSYBOX_FOR_ARCH="./busyboxes/${TARGET_ARCH}/busybox"
if [ -f ${BUSYBOX_FOR_ARCH} ]; then
	cat ${BUSYBOX_FOR_ARCH} > ./for_ftp_upload/pub/OWL/bin/busybox
else
	echo "Error: No busybox for TARGET_ARCH: ${TARGET_ARCH} !!!"
fi
