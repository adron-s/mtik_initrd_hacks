#!/bin/bash

OPENWRT_DIR=/home/prog/openwrt/lede-all/2019-openwrt-all/openwrt-ipq806x
export STAGING_DIR=$OPENWRT_DIR/staging_dir/toolchain-arm_cortex-a15+neon-vfpv4_gcc-7.4.0_musl_eabi
#OPENWRT_DIR=/home/prog/openwrt/lede-all/2019-openwrt-all/openwrt-ipq4xxx
#export STAGING_DIR=${OPENWRT_DIR}/staging_dir/toolchain-arm_cortex-a7+neon-vfpv4_gcc-7.4.0_musl_eabi

GCC=$STAGING_DIR/bin/arm-openwrt-linux-gcc
OD=$STAGING_DIR/bin/arm-openwrt-linux-objdump
OC=$STAGING_DIR/bin/arm-openwrt-linux-objcopy
LD=$STAGING_DIR/bin/arm-openwrt-linux-ld

$GCC -static ./init.c -o ../cpio-fs/init
$OC --strip-all ../cpio-fs/init ../cpio-fs/init
