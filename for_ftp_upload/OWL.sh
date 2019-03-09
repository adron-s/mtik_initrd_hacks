ROOT=/flash/rw/disk/OWL
cd $ROOT
[ -f $ROOT/bin/busybox -a ! -f $ROOT/bin/sh  ] && {
	echo "Initializing busybox"
  chmod 700 $ROOT/bin/busybox
  $ROOT/bin/busybox --install -s $ROOT/bin
}
export PATH="/rw/disk/OWL/bin:$PATH"
echo "Launching telnetd"
busybox chroot /system telnetd -p 22111 -F -l bash
