#!/bin/sh

WORKDIR="/home/prog/openwrt/lede-all/new-lede-rb941/source"

HOST="172.20.1.1"
USER="admin"
PASS=${FTP_UPLOAD_PASS}
[ -z ${PASS} ] && {
	echo "just do# export FTP_UPLOAD_PASS=xYz"
	exit 1
}
FILE=./bins/kernel-new.elf
FAKEFNAME="linux_t1.bin"
[ "$HOST" = "127.0.0.1" ] && {
	cat $FILE > /var/lib/tftpboot/$FAKEFNAME
	exit 0
}
ftp -inv $HOST << EOF
user $USER $PASS
put $FILE $FAKEFNAME
bye
EOF

exit 0
