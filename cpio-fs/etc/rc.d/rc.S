#!/bin/sh

/bin/busybox --install /bin

mount -v proc /proc -n -t proc
mount -v sysfs /sys -n -t sysfs
mount -v devtmpfs /dev -n -t devtmpfs

sh
