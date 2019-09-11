#!/bin/sh

#TARGET=./ros/routeros-arm-6.44.npk
#TARGET=./ros/routeros-7.0beta1-arm.npk
TARGET=${1}
FS_BEGIN_OFFSET=4096

get_squashfs_size(){
	binwalk ${TARGET} | grep "Squashfs filesystem" | sed -n 's/.* size: \([0-9]\+\) bytes.*/\1/p'
}

FS_SIZE=$(get_squashfs_size)
[ -z "${FS_SIZE}" ] && {
	echo "Can't find Squashfs filesystem! in ${TARGET}"
	exit 1
}

rm -f ./bins/*

dd if=${TARGET} of=./bins/rootfs.squashfs bs=1 skip=${FS_BEGIN_OFFSET} count=${FS_SIZE}
#dd if=${TARGET} of=./tail.bin bs=$((${FS_BEGIN_OFFSET}+${FS_SIZE})) skip=1
./finder/kernel-extractor ${TARGET} ./bins/kernel.bin

exit 0
