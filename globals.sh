#!/bin/sh
#
#(C) Sergey Sergeev aka adron, 2019
#

#TARGET_ARCH="arm"
TARGET_ARCH="mips"

[ ${TARGET_ARCH} = "arm" ] && {
	OPENWRT_DIR=/home/prog/openwrt/lede-all/2019-openwrt-all/openwrt-ipq806x
	export STAGING_DIR=$OPENWRT_DIR/staging_dir/toolchain-arm_cortex-a15+neon-vfpv4_gcc-7.4.0_musl_eabi
	#OPENWRT_DIR=/home/prog/openwrt/lede-all/2019-openwrt-all/openwrt-ipq4xxx
	#export STAGING_DIR=${OPENWRT_DIR}/staging_dir/toolchain-arm_cortex-a7+neon-vfpv4_gcc-7.4.0_musl_eabi
}

[ ${TARGET_ARCH} = "mips" ] && {
	#I use: https://downloads.openwrt.org/releases/18.06.4/targets/ar71xx/generic/openwrt-sdk-18.06.4-ar71xx-generic_gcc-7.3.0_musl.Linux-x86_64.tar.xz
	OPENWRT_DIR=/home/prog/openwrt/lede-all/2019-openwrt-all/openwrt-sdk-18.06.4-ar71xx-generic_gcc-7.3.0_musl.Linux-x86_64
	export STAGING_DIR=$OPENWRT_DIR/staging_dir/toolchain-mips_24kc_gcc-7.3.0_musl
}

GCC=$STAGING_DIR/bin/${TARGET_ARCH}-openwrt-linux-gcc
OBJDUMP=$STAGING_DIR/bin/${TARGET_ARCH}-openwrt-linux-objdump
OBJCOPY=$STAGING_DIR/bin/${TARGET_ARCH}-openwrt-linux-objcopy
LD=$STAGING_DIR/bin/${TARGET_ARCH}-openwrt-linux-ld
