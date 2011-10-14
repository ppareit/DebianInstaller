#!/bin/sh

TMPDIR=/tmp
IMAGENAME=debian.img
IMAGESIZE=2GB
ARCH=armel
SUITE=squeeze

IMAGEFILE=$TMPDIR/$IMAGENAME
MOUNTPOINT=$TMPDIR/debian

# TODO: probably writeing one to mutch
dd if=/dev/zero of=$IMAGEFILE seek=$IMAGESIZE bs=1 count=1
mke2fs -F $IMAGEFILE
mkdir $MOUNTPOINT
mount -o loop $IMAGEFILE $MOUNTPOINT
debootstrap --verbose --arch $ARCH --foreign $SUITE $MOUNTPOINT http://ftp.de.debian.org/debian
umount $MOUNTPOINT

