ROOT=${1}/OWL
cd $ROOT
[ -f $ROOT/bin/busybox -a ! -f $ROOT/bin/sh  ] && {
	echo "Initializing busybox"
  #chmod 700 $ROOT/bin/busybox
  $ROOT/bin/busybox --install -s $ROOT/bin
}
export PATH="$ROOT/bin:$PATH"
#cd $ROOT
#ls ./bin/sh
#exit 0
while [ ! -d /system ]; do
	echo "Waiting for /system dir ready"
	sleep 5
done
echo "Launching telnetd"
busybox chroot /system telnetd -p 22111 -F -l sh
