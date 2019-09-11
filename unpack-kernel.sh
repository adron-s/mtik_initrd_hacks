#!/bin/sh
#
#(C) Sergey Sergeev aka adron, 2019
#

_kernel_bin_binwalk=""
kernel_bin_binwalk(){
	[ -z "${_kernel_bin_binwalk}" ] && \
		_kernel_bin_binwalk=$(binwalk ./bins/kernel.bin)
	echo "${_kernel_bin_binwalk}"
}

get_xz_offsets(){
	kernel_bin_binwalk | grep "xz compressed data" | sed -n 's/^\([0-9]\+\).*/\1/p'
}

get_file_size(){
	[ -f ${1} ] || {
		echo 0
		return 0
	}
	du -b ${1} | sed -e 's/\([0-9]\+\).*/\1/'
}

unpack_kernel_bin(){
	local xz_offsets
	local p_count=0
	local pred_offset
	local size
	local offset
	xz_offsets=$(get_xz_offsets)
	for offset in ${xz_offsets} 0; do
		#echo $offset
		[ -n "${pred_offset}" ] && {
			p_count=$((${p_count}+1))
			size=$((${offset}-${pred_offset}))
			[ ${offset} -eq 0 ] && size=104857600
			echo "$p_count - ${pred_offset} - ${size}"
			dd if=./bins/kernel.bin of=./bins/kernel.p${p_count}.xz bs=1 skip=${pred_offset} count=${size}
		}
		pred_offset=${offset}
	done
}

extract_kernel_elf(){
	local offsets
	local offset
	local kernel_elf_size=0
	offsets=`kernel_bin_binwalk | sed -n 's/ELF,//p' | sed -n 's/^\([0-9]\+\).*/\1/p'`
	local elf_last_offset
	local first_xz_offset
	for offset in ${offsets}; do
		elf_last_offset=${offset}
	done
	[ -n "${elf_last_offset}" ] && {
		offsets=$(get_xz_offsets)
		for offset in ${offsets}; do
			first_xz_offset=${offset}
			break
		done
		#elf size without xz
		kernel_elf_size=$((${first_xz_offset}-${elf_last_offset}))
		local p
		local size
		for p in $(seq 1 3); do
			size=$(get_file_size ./bins/kernel.p${p}.xz)
			kernel_elf_size=$((${kernel_elf_size}+${size}))
		done
		dd if=./bins/kernel.bin bs=1 skip=${elf_last_offset} count=${kernel_elf_size} of=./bins/kernel.elf
		[ -f ./bins/p3-garbage.bin ] && {
			offset=484 #[ 45 00 00 00  00 00 00 00  00 00 00 00  01 00 00 00 ] <-- ${offset}
			dd if=./bins/p3-garbage.bin bs=${offset} count=1 >> ./bins/kernel.elf
		}
	}
}

truncate_kernel_p3(){
	local garbage_size
	local p3_size
	garbage_size=$(get_file_size ./bins/p3-garbage.bin)
	p3_size=$(get_file_size ./bins/kernel.p3.xz)
	dd if=./bins/kernel.p3.xz of=./bins/kernel.p3-stripped.xz bs=$((${p3_size}-${garbage_size})) count=1
	cat ./bins/kernel.p3-stripped.xz > ./bins/kernel.p3.xz
	rm ./bins/kernel.p3-stripped.xz
}

unpack_kernel_bin

( xz -dc --single-stream > ./bins/initramfs.cpio && cat > ./bins/p3-garbage.bin ) < ./bins/kernel.p3.xz
#do kerne.p3.xz fix(cut garbage)
[ -f ./bins/p3-garbage.bin ] && {
	truncate_kernel_p3
}

extract_kernel_elf

exit 0

rm -Rf cpio-fs
mkdir cpio-fs
cd cpio-fs
cpio -idv < ../bins/initramfs.cpio
