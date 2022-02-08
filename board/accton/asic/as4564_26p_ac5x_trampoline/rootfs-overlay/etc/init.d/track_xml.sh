#!/bin/sh

sleep 60
if [ ! -f /sys/class/net/sw1p1/device/dev ]
then
	echo sw1p1 not present after 60 seconds, restoring XML from RO initramfsand rebooting system...
	echo "sw1p1 not present after 60 seconds, restoring XML from RO initramfs and rebooting system" >> /var/log/xml.log
	cp /etc/mvsw/mvsw_platform.ro /mnt/etc/mvsw/mvsw_platform.xml
	md5sum /etc/mvsw/mvsw_platform.ro > /mnt/etc/mvsw/mvsw_platform.md5
	sync
	umount /dev/mmcblk0p1
	reboot
fi

