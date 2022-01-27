#!/bin/sh
#
#(C) Sergey Sergeev aka adron, 2019-2021
#

#rb5009
#TARGET_ARCH="aarch64"
#rb3011(ipq806x), rb450dx4(ipq401x)
TARGET_ARCH="arm"
#ath79, ramips
#TARGET_ARCH="mips"

TOOLS_BINS_PREFIX="openwrt-linux"

[ ${TARGET_ARCH} = "aarch64" ] && {
	OPENWRT_DIR=/home/prog/openwrt/2021-openwrt/last-openwrt/openwrt
	export STAGING_DIR=$OPENWRT_DIR/staging_dir/toolchain-aarch64_cortex-a72_gcc-11.2.0_musl
	TOOLS_BINS_PREFIX="$TOOLS_BINS_PREFIX-musl"
}

[ ${TARGET_ARCH} = "arm" ] && {
	#OPENWRT_DIR=/home/prog/openwrt/lede-all/2019-openwrt-all/openwrt-ipq806x
	#export STAGING_DIR=$OPENWRT_DIR/staging_dir/toolchain-arm_cortex-a15+neon-vfpv4_gcc-7.4.0_musl_eabi
	#OPENWRT_DIR=/home/prog/openwrt/lede-all/2019-openwrt-all/openwrt-ipq4xxx
	#export STAGING_DIR=${OPENWRT_DIR}/staging_dir/toolchain-arm_cortex-a7+neon-vfpv4_gcc-7.4.0_musl_eabi
	GCC=arm-linux-gnueabi-gcc
	OBJDUMP=arm-linux-gnueabi-objdump
	OBJCOPY=arm-linux-gnueabi-objcopy
	LD=arm-linux-gnueabi-ld
}

[ ${TARGET_ARCH} = "mips" ] && {
	#I use: https://downloads.openwrt.org/releases/18.06.4/targets/ar71xx/generic/openwrt-sdk-18.06.4-ar71xx-generic_gcc-7.3.0_musl.Linux-x86_64.tar.xz
	OPENWRT_DIR=/home/prog/openwrt/lede-all/2019-openwrt-all/openwrt-sdk-18.06.4-ar71xx-generic_gcc-7.3.0_musl.Linux-x86_64
	export STAGING_DIR=$OPENWRT_DIR/staging_dir/toolchain-mips_24kc_gcc-7.3.0_musl
}

#GCC=$STAGING_DIR/bin/${TARGET_ARCH}-${TOOLS_BINS_PREFIX}-gcc
#OBJDUMP=$STAGING_DIR/bin/${TARGET_ARCH}-${TOOLS_BINS_PREFIX}-objdump
#OBJCOPY=$STAGING_DIR/bin/${TARGET_ARCH}-${TOOLS_BINS_PREFIX}-objcopy
#LD=$STAGING_DIR/bin/${TARGET_ARCH}-${TOOLS_BINS_PREFIX}-ld
