#!/bin/sh
# parameters: partition binary, root file system, complete emmc binary
rm $1
rm $3
rm $3.gz
dd if=/dev/zero bs=1M count=2048 > $3
(
echo o
echo n
echo p
echo 1
echo 
echo +2000M
echo w
) | fdisk $3
mke2fs \
-d "$2" \
-r 1 \
-N 0 \
-m 5 \
-L '' \
-O ^64bit \
"$1" \
"2000M" \
;
dd if=$1 of=$3 bs=1024 seek=1024 count=2048000
rm $1
echo Compressing emmc.bin into emmc.bin.gz ...
echo Please uncompress it with the unzip command
echo in u-boot ...
gzip $3
echo Finished compression.

