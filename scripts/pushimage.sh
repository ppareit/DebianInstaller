#!/bin/sh

TMPDIR=/tmp
IMAGENAME=debian.img
IMAGEFILE=$TMPDIR/$IMAGENAME

DEVICEIMAGEFILE="/sdcard/debian/debian.img"

# TODO: use 'mount' on android device to know where /system is mounted
echo "Remounting /system as rw"
adb shell su -c 'mount -o remount,rw -t yaffs2 /dev/block/mmcblk0p1 /system'

echo "Pushing ch2debian script"
adb push ch2debian.sh /system/bin/ch2debian
adb shell su -c 'chmod 755 /system/bin/ch2debian'

echo "Remounting /system as read only"
adb shell su -c 'mount -o remount,ro -t yaffs2 /dev/block/mmcblk0p1 /system'


echo "Pushing image... (lengthy operation)"
adb push $IMAGEFILE $DEVICEIMAGEFILE

echo "Finished pushing image"

