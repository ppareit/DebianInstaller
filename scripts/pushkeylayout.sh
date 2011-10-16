#!/bin/sh

if [ $# -ne 2 ]
then
    echo "Usage - $0 device layout"
    echo "           Where device currently is only TF101 and layout currently only is BE"
    echo "           Contact me to support more devices"
    exit 1
fi

case $1 in
    TF101)
	case $2 in
	    BE)
		echo "Remounting /system as read/write"
		adb shell su -c 'mount -o remount,rw -t yaffs2 /dev/block/mmcblk0p1 /system'
		echo "Pushing keylayout to device"
		adb push ../data/keylayouts/TF101/BE/asusec.kl /system/usr/keylayout/asusec.kl
		echo "Pushing keychars to device"
		adb push ../data/keychars/TF101/BE/asusec.kcm /system/usr/keychars/asusec.kcm
		echo "Remounting system as read only"
		adb shell su -c 'mount -o remount,ro -t yaffs2 /dev/block/mmcblk0p1 /system'
		;;
	esac
	;;
    *)
	echo "Unknown device"
	exit 1
	;;
esac

echo "For the changes to have effect, you have to reboot the device."