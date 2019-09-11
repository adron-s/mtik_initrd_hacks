#!/bin/bash
#
#(C) Sergey Sergeev aka adron, 2019
#

OPENWRT_DIR=/home/prog/openwrt/lede-all/2019-openwrt-all/LAST/openwrt
export STAGING_DIR=$OPENWRT_DIR/staging_dir/toolchain-arm_cortex-a15+neon-vfpv4_gcc-9.2.0_glibc_eabi
TOOLCHAIN_PREFIX="arm-openwrt-linux-"
#export STAGING_DIR=$OPENWRT_DIR/staging_dir/toolchain-arm_cortex-a15+neon-vfpv4_gcc-9.2.0_musl_eabi
#TOOLCHAIN_PREFIX="arm-openwrt-linux-muslgnueabi"
#OPENWRT_DIR=/home/prog/openwrt/lede-all/2019-openwrt-all/openwrt-ipq806x
#export STAGING_DIR=$OPENWRT_DIR/staging_dir/toolchain-arm_cortex-a15+neon-vfpv4_gcc-7.4.0_musl_eabi
#TOOLCHAIN_PREFIX=arm-openwrt-linux
#OPENWRT_DIR=/home/prog/openwrt/lede-all/2019-openwrt-all/openwrt-ipq4xxx
#export STAGING_DIR=${OPENWRT_DIR}/staging_dir/toolchain-arm_cortex-a7+neon-vfpv4_gcc-7.4.0_musl_eabi

GCC=$STAGING_DIR/bin/${TOOLCHAIN_PREFIX}-gcc
OD=$STAGING_DIR/bin/${TOOLCHAIN_PREFIX}-objdump
OC=$STAGING_DIR/bin/${TOOLCHAIN_PREFIX}-objcopy
LD=$STAGING_DIR/bin/${TOOLCHAIN_PREFIX}-ld

$GCC -static ./init.c -o ../cpio-fs/init
$OC --strip-all ../cpio-fs/init ../cpio-fs/init

exit 0

cd ../
./pack-kernel.sh
./ftp_upload.sh
