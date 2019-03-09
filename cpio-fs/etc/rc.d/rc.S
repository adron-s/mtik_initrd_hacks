#!/bin/sh

/bin/busybox --install /bin

mount -v proc /proc -n -t proc

sh
