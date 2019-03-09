#!/bin/sh

OPENWRT_DIR=/home/prog/openwrt/lede-all/2019-openwrt-all/openwrt-ipq806x
export STAGING_DIR=$OPENWRT_DIR/staging_dir/toolchain-arm_cortex-a15+neon-vfpv4_gcc-7.4.0_musl_eabi
#OPENWRT_DIR=/home/prog/openwrt/lede-all/2019-openwrt-all/openwrt-ipq4xxx
#export STAGING_DIR=${OPENWRT_DIR}/staging_dir/toolchain-arm_cortex-a7+neon-vfpv4_gcc-7.4.0_musl_eabi

GCC=$STAGING_DIR/bin/arm-openwrt-linux-gcc
OBJDUMP=$STAGING_DIR/bin/arm-openwrt-linux-objdump
OBJCOPY=$STAGING_DIR/bin/arm-openwrt-linux-objcopy
LD=$STAGING_DIR/bin/arm-openwrt-linux-ld

${OBJDUMP} -x kernel.elf > ./kernel.headers
#${OBJDUMP} -x kernel-new.elf > ./kernel.headers

#${OBJCOPY} -j .text -j initrd -S ./kernel.elf ./kernel.OWL1
#${OBJCOPY} -R initrd -S ./kernel.elf ./kernel.OWL1
#${OBJCOPY} -j .rodata -O binary ./kernel.elf ./kernel.OWL1

#initrd is kernel.p2-p3
