#!/bin/sh
#
#(C) Sergey Sergeev aka adron, 2019
#


OPENWRT_DIR=/home/prog/openwrt/lede-all/2019-openwrt-all/openwrt-ipq806x
export STAGING_DIR=$OPENWRT_DIR/staging_dir/toolchain-arm_cortex-a15+neon-vfpv4_gcc-7.4.0_musl_eabi
#OPENWRT_DIR=/home/prog/openwrt/lede-all/2019-openwrt-all/openwrt-ipq4xxx
#export STAGING_DIR=${OPENWRT_DIR}/staging_dir/toolchain-arm_cortex-a7+neon-vfpv4_gcc-7.4.0_musl_eabi

GCC=$STAGING_DIR/bin/arm-openwrt-linux-gcc
OBJDUMP=$STAGING_DIR/bin/arm-openwrt-linux-objdump
OBJCOPY=$STAGING_DIR/bin/arm-openwrt-linux-objcopy
LD=$STAGING_DIR/bin/arm-openwrt-linux-ld

ROOT=$(pwd)
cd ./cpio-fs
find . 2>/dev/null | cpio --quiet -o --format='newc' | \
	xz --check=crc32 --lzma2=dict=512KiB > ${ROOT}/bins/kernel.p3-new.xz
cd ${ROOT}

cat ./bins/kernel.p2.xz ./bins/kernel.p3-new.xz > ./bins/kernel-new.combo
#cat ./bins/kernel.p2.xz ./bins/kernel.p3.xz > ./bins/kernel-new.combo
${OBJCOPY} --update-section initrd=./bins/kernel-new.combo ./bins/kernel.elf ./bins/kernel-new.elf

#cat ./bins/kernel-new.elf > /var/lib/tftpboot/linux_t1.bin
