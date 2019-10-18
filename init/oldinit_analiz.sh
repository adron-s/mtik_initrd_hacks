#!/bin/bash
#
#(C) Sergey Sergeev aka adron, 2019
#

. ../globals.sh

CPIO_FS="../cpio-fs-${TARGET_ARCH}"

$OBJDUMP ${CPIO_FS}/oldinit -x > ./oldinit.objdump
$OBJDUMP ${CPIO_FS}/init -x > ./init.objdump
