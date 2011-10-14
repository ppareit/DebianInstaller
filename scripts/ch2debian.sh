#########################
# Debdroid General Config
#########################

# Name server configuration
NAMESERVER1=8.8.8.8
NAMESERVER2=8.8.4.4

# Chroot Hostname
CHOSTNAME="debian"

# Loop Device Number, keep 255 if you want apps2sd support
LOOPNO=101

# Path to Linux Image
IMG="/sdcard/debian/debian.img"

#########################
# End of Config
#########################

#required for mount -o to function
init() {
ifconfig eth0 promisc #must be initialized or will crash when doing it on debian

export bin=/system/bin
if [ ! -d /data/local/debian ]
then
	mkdir /data/local/debian
fi

export mnt=/data/local/debian
export PATH=$bin:/usr/bin:/usr/sbin:/bin:$PATH
export TERM=linux
export USER=root
export HOME=/root
}

# Mount the debian image to a loopback device
loop() {
loop="/dev/block/loop$LOOPNO"
mknod $loop b 7 $LOOPNO 2>> /dev/null
losetup /dev/block/loop$LOOPNO $IMG
mount -t ext2 /dev/block/loop$LOOPNO $mnt
}


# Mount necessary system dirs
sysmount() {
mount -t proc proc $mnt/proc
mount -t sysfs sysfs $mnt/sys
mount -o bind /dev $mnt/dev
mount -t devpts devpts $mnt/dev/pts
}

# Setup DNS and hostname
networking() {
sysctl -w net.ipv4.ip_forward=12 >> /dev/null
echo "Setting $NAMESERVER1 and $NAMESERVER2 as nameservers in /etc/resolv.conf"
echo "nameserver $NAMESERVER1" > $mnt/etc/resolv.conf 2>> /dev/null
echo "nameserver $NAMESERVER2" >> $mnt/etc/resolv.conf 2>> /dev/null
echo "Setting localhost and hostname \"$CHOSTNAME\" in /etc/hosts " 2>> /dev/null
echo "127.0.0.1 localhost $CHOSTNAME" > $mnt/etc/hosts 2>> /dev/null 
echo "$CHOSTNAME" > $mnt/etc/hostname
}

# Start chroot
change_root() {
chroot $mnt bash -c "hostname $CHOSTNAME"
# Mount home dir with cryptsetup. Comment this out if you don't need it.
#chroot $mnt bash -c "/usr/local/bin/mnt_home open"
chroot $mnt /bin/bash
}

#After exit command is executed clean it all up
cleanup() {
echo
echo "Exiting chroot"
# Unmount crypted home dir. Comment out if not needed.
#chroot $mnt bash -c "/usr/local/bin/mnt_home close"
umount $mnt/dev/pts
umount $mnt/dev
umount $mnt/proc 
umount $mnt/sys 
umount $mnt
losetup -d $loop
echo "Filesystem unmounted"
}

echo "Initializing chroot filesystem"
init
loop
echo
echo "Mounting proc, sysfs, dev, devpts"
sysmount
echo
echo "Setting up DNS and Networking"
echo
networking
echo "Debian deployed successfully, opening chroot."
change_root
cleanup
