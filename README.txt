内核，文件系统等大文件请移步https://pan.baidu.com/s/1kPK2hhPItf03pjaPY13Kog，提取码lb4y

########################################################################
# 内核编译步骤
########################################################################
$ tar -xf linux-4.14.1.tar.xz
$ cd linux-4.14.1/
$ git init
$ git add -A
$ git commit -m "the original source code of linux-4.14.1"
$ tar -xf ../yaffs2-HEAD-27f1820.tar.gz -C ..
$ cd ../yaffs2-HEAD-27f1820/
$ ./patch-ker.sh c m ../linux-4.14.1
$ cd ../linux-4.14.1/
$ git apply ../jz2440.patch
$ make ARCH=arm jz2440_defconfig
$ make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- uImage


########################################################################
# 文件系统编译步骤
########################################################################
$ tar -xf busybox-1.21.0.tar.bz2
$ cd busybox-1.21.0/
$ make ARCH=arm CROSS_COMPILE=arm-linux- menuconfig
	Busybox Settings--->Build Options:
		[*] Build BusyBox as a static binary (no shared libs)
		(arm-linux-) Cross Compiler prefix
	# save the configuration when you exit 
$ make ARCH=arm CROSS_COMPILE=arm-linux- install
$ cd ..
$ chmod +x mkyaffs2image busybox_patch.sh
$ ./busybox_patch.sh busybox-1.21.0/_install/ arm-linux-gcc
$ ./mkyaffs2image busybox-1.21.0/_install/ jz2440_yaffs2.bin
