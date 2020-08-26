# Mikrotik netboot/initrd jailbreak

(C) Sergey Sergeev, 2019-2020

All that you do is at your own risk!
The author has not liable for any of you actions and their consequences!
This code is presented as is and is solely for educational purposes ONLY!

0) Use RouterOS 6.44 or 6.45.6 or 7.0b1!
1) Upload(using FTP) content of ./for_ftp_upload/pub/* to /pub
     (or /flash or /flash/rw/disk/pub) folder on target RouterOS device
2) Netboot(via bootp and tftp) with kernel-new.elf
3) telnet x.x.x.x 22111

Все что вы делаете, вы делаете на свой страх и риск!
Автор не несет никакой ответственности за ваши действия и их последствия!
Данный код представляется as-is и исключительно в учебных целях!

For Developers:
	Place routeros-XXX.mpk to ./ros/
	cd ./finder
	./Build.sh
	cd ..
	edit ./globals.sh and set your target device ARCH: arm or mips
	./unpack-npk.sh ./ros/routeros-mipsbe-6.45.6.npk
	./unpack-kernel.sh
	cd ./init
	./compile.sh
	cd ..
	Make the necessary changes to the ./cpio-fs-ARCH(copy oldinit && order from ./bins/initramfs.cpio, compile add add busybox, etc...)
	In the end, when everything is ready, to get ./bins/kernel-new.elf, run: ./pack-kernel.sh
	Upload content of ./for_ftp_upload/pub/* to target RouterOS device via FTP(to /pub or /flash or ...)
	Put ./bins/kernel-new.elf to your tftp and Netboot from it
	telnet x.x.x.x 22111
