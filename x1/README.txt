These files are obtained by the following commands:
dd if=./ros/routeros-7.1rc4-arm.npk of=x1/x1-32b.bin bs=$((0x009ee000)) skip=1
dd if=./ros/routeros-7.1rc4-arm.npk of=x1/x1-64b.bin bs=$((0x00a06000)) skip=1
0x009ee000 and 0x00a06000 is obtained from ./unpack-npk.sh ./ros/routeros-7.1rc4-arm.npk:
..
  Kernel header(start magic) is found at: 0x009ee000
.
