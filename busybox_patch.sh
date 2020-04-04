#!/bin/bash

if [ $# -ne 2 ]; then
    echo wrong parameter!
    echo usage: ./busybox_patch.sh /the/busybox/_install/dir/ /the/cross-compiler-name/e.g:arm-linux-gcc
    exit 1
fi

echo the busybox path: $1
echo the cross compiler is: $2

# [1] copy lib
LIBPATH=$(find /home/sam/Work/jz2440/gcc-4.3.2_arm-linux-gnueabi/ -regex ".*armv4t.*libc\.so\.6")
LIBPATH=${LIBPATH%libc.so.6}
mkdir $1/lib
cp $LIBPATH/*.so* $1/lib -d

# [2]
mkdir $1/etc
touch $1/etc/inittab
a="# /etc/inittab
::sysinit:/etc/init.d/rcS
ttySAC0::askfirst:-/bin/sh
#s3c2410_serial0::askfirst:-/bin/sh
::ctrlaltdel:/sbin/reboot
::shutdown:/bin/umount -a -r"
cat>$1/etc/inittab<<EOF
$a
EOF

# [3]
mkdir -p $1/etc/init.d
touch $1/etc/init.d/rcS
chmod +x $1/etc/init.d/rcS
b="#!/bin/sh
#ifconfig eth0 192.168.1.17
mount -a
mkdir /dev/pts
mount -t devpts devpts /dev/pts
echo /sbin/mdev > /proc/sys/kernel/hotplug
mdev -s"
cat>$1/etc/init.d/rcS<<EOF
$b
EOF

# [4]
touch $1/etc/fstab
c="# device     mount-point     type    options         dump    fsck    order
proc    /proc       proc    defaults    0   0
tmpfs   /tmp        tmpfs   defaults    0   0
sysfs   /sys        sysfs   defaults    0   0
tmpfs   /dev        tmpfs   defaults    0   0"
cat>$1/etc/fstab<<EOF
$c
EOF

# [5]
mkdir $1/dev
sudo mknod $1/dev/console c 5 1
sudo mknod $1/dev/null c 1 3

# [6]
mkdir $1/proc $1/mnt $1/tmp $1/sys $1/root

echo done
