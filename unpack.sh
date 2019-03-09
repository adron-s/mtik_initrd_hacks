#!/bin/sh
#
#(C) Sergey Sergeev aka adron, 2019
#

#exit 0

#for 6.43 kernel
#dd if=kernel.elf bs=1 skip=0 count=43504 of=./bins/kernel.HEAD
#dd if=kernel.elf bs=1 skip=43504 count=1605632 of=./bins/kernel.p2.xz
#dd if=kernel.elf bs=1 skip=1649136 count=84812 of=./bins/kernel.p3.xz
#dd if=kernel.elf bs=1 skip=1733948 of=./bins/kernel.TAIL

#for 6.44 kernel
dd if=kernel.elf bs=1 skip=43752 count=1609728 of=./bins/kernel.p2.xz
dd if=kernel.elf bs=1 skip=1653480 count=85128 of=./bins/kernel.p3.xz


#( xz -dc --single-stream > ./bins/initramfs.cpio && cat > ./bins/p3-tail.bin ) < ./bins/kernel.p3.xz
xz -dc > ./bins/initramfs.cpio < ./bins/kernel.p3.xz

exit 0

rm -Rf cpio-fs
mkdir cpio-fs
cd cpio-fs
cpio -idv < ../bins/initramfs.cpio
