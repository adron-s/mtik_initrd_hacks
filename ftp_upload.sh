#!/bin/sh

HOST="127.0.0.1"
USER="admin"
PASS=${FTP_UPLOAD_PASS}
[ -z ${PASS} ] && [ ${HOST} != "127.0.0.1" ] && {
	echo "just do# export FTP_UPLOAD_PASS=xYz"
	exit 1
}
FILE=./bins/kernel-new.elf
FAKEFNAME="linux_t1.bin"
[ "$HOST" = "127.0.0.1" ] && {
	cat $FILE > /var/lib/tftpboot/$FAKEFNAME
	echo "$FILE > /var/lib/tftpboot/$FAKEFNAME"
	exit 0
}
ftp -inv $HOST << EOF
user $USER $PASS
put $FILE $FAKEFNAME
bye
EOF

exit 0
