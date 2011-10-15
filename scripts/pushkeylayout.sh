#!/bin/sh

if [ $# -ne 2]
then
    echo "Usage - $0 device layout"
    echo "           Where device currently is only TF101 and layout currently only is BE"
    echo "           Connact me to support more devices"
    exit 1
fi

case $1 in
    TF101)
	case $2 in
	    BE)
		echo "Remounting /system as rw"
		adb shell su -c 'mount -o remount,rw -t yaffs2 /dev/block/mmcblk0p1 /system'
		echo "Pushing keylayout to device"
		adb push ../data/transformer/keylayout/asusec.kl.be /system/usr/keylayout/asusec.kl
	;;
    *)
	echo "Unknown device"
	exit 1
	;;
esac