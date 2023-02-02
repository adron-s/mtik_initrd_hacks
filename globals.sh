#!/bin/sh
#
#(C) Sergey Sergeev aka adron, 2019-2021
#

#rb5009
#TARGET_ARCH="aarch64"
#rb3011(ipq806x), rb450dx4(ipq401x)
TARGET_ARCH="arm"
#TARGET_ARCH="mipsel"
#ath79, ramips
#TARGET_ARCH="mips"

TOOLS_BINS_PREFIX="openwrt-linux"

[ ${TARGET_ARCH} = "aarch64" ] && {
	OPENWRT_DIR=/home/prog/openwrt/2021-openwrt/last-openwrt/openwrt
	export STAGING_DIR=$OPENWRT_DIR/staging_dir/toolchain-aarch64_cortex-a72_gcc-11.2.0_musl
	TOOLS_BINS_PREFIX="$TOOLS_BINS_PREFIX-musl"
}

[ ${TARGET_ARCH} = "arm" ] && {
	OPENWRT_DIR=/home/prog/openwrt/2023-openwrt/openwrt-2023
	export STAGING_DIR=$OPENWRT_DIR/staging_dir/toolchain-arm_cortex-a7+neon-vfpv4_gcc-11.2.0_musl_eabi
}

[ ${TARGET_ARCH} = "mips" ] && {
	OPENWRT_DIR=/home/prog/openwrt/2023-openwrt/openwrt-2023
	export STAGING_DIR=$OPENWRT_DIR/staging_dir/toolchain-mips_24kc_gcc-11.2.0_musl
}

[ ${TARGET_ARCH} = "mipsel" ] && {
	OPENWRT_DIR=/home/prog/openwrt/2023-openwrt/openwrt-2023
	export STAGING_DIR=$OPENWRT_DIR/staging_dir/toolchain-mipsel_24kc_gcc-11.2.0_musl
}

[ -z "${GCC}" ] && {
	GCC=$STAGING_DIR/bin/${TARGET_ARCH}-${TOOLS_BINS_PREFIX}-gcc
	OBJDUMP=$STAGING_DIR/bin/${TARGET_ARCH}-${TOOLS_BINS_PREFIX}-objdump
	OBJCOPY=$STAGING_DIR/bin/${TARGET_ARCH}-${TOOLS_BINS_PREFIX}-objcopy
	LD=$STAGING_DIR/bin/${TARGET_ARCH}-${TOOLS_BINS_PREFIX}-ld
}
