# Mikrotik netboot/initrd jailbreak

(C) Sergey Sergeev, 2019-2021

All that you do is at your own risk!
The author has not liable for any of you actions and their consequences!
This code is presented as is and is solely for educational purposes ONLY! -
to investigate the internals of a Linux distro called RouterOS.
In particular, to facilitate porting OpenWRT to new Mikrotik devices.
For injection(jailbreak) to RouterOS is used the standard(for almost any Linux)
initrd mechanism. Native binary init file is replaced with a fake one. This modified
init forks itself (spawning its daemon copy) and then pass control to the original init
process. The begotten daemon copy waits for the filesystem to initialize and installs
busybox and then launch the telnetd service. To run Linux kernel with modified init file,
uses the standard RouterBOOT ability - loading from network using dhcp/bootp and tftp
server. dhcp/bootp server can be deployed on another device with RouterOS and OpenWRT or
even tftp32 program. For a one-time launch with tftp, You can use this commands in RouterOS:
	
	/system/routerboard/settings/set boot-device=try-ethernet-once-then-nand
	/system/reboot

and after that do the following:

0) Use RouterOS 6.44 or 6.45.6 or 7.x(7.1rc4)!
1) Upload(using FTP) content of ./for_ftp_upload/pub/* to /pub
     (or /flash or /flash/rw/disk/pub) folder on target RouterOS device
2) Netboot(via bootp and tftp) with kernel-new.elf
3) telnet x.x.x.x 22111

Cyrillic:

Все что вы делаете, вы делаете на свой страх и риск!
Автор не несет никакой ответственности за ваши действия и их последствия!
Данный код представляется as-is и исключительно в учебных целях -
для исследования внутреннего устройства дистрибутива Linux под названием
RouterOS. В частностия для облегчения портирования OpenWRT на новые
устройства от Mikrotik. Для внедрения(jailbreak-а) в RouterOS используется
стандартный(практически для любого Linux-а) механизм initrd. Родной бинарный
файл init-а заменяется на поддельный. Этот измененный init форкает себя(порождая
свою копию-демона) и дальше передает управление родному init процессу. Порожденная
копия-демон ожидает инициализации файловой системы и запускает скрипт установки
busybox с последующим запуском telnetd сервиса. Для запуска ядра Linux с измененным
init файлом используется штатный механизм RouterBOOT - загрузка через сеть
с использованием dhcp/bootp и tftp сервера. dhcp/bootp сервером может выступать
как другое устройство с RouterOS так и OpenWRT или даже программа tftp32.
Для единоразового запуска с tftp вы можете выполнить следующие команды в RouterOS:

	/system/routerboard/settings/set boot-device=try-ethernet-once-then-nand
	/system/reboot

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
