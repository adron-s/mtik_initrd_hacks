#!/bin/sh

/bin/busybox --install -s /bin

reset
echo ""
echo "Starting system...."

mount -v proc /proc -n -t proc
mount -v sysfs /sys -n -t sysfs
mount -v devtmpfs /dev -n -t devtmpfs

echo "Done. Enjoy the power of linux."
echo
echo "Reboot is not working!"
echo "So just type an exit if you want for reboot."
echo

sh

echo "Reboot(r) or start RouterOS(s) ?"
ANSV="r"
read -n1 ANSV

[ "${ANSV}" == "r" ] && exit 0

echo "Ok. Ok. Let's run an RouterOS"
/oldinit
