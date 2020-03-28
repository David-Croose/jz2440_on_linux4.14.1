移植JZ2440到4.x内核。

怎样使用这个补丁：
$ cd ~
$ git clone https://github.com/David-Croose/jz2440_on_linux4.x.git
$ cd <你的内核目录>
$ git apply  ~/jz2440.patch
$ make ARCH=arm jz2440_defconfig
$ make ARCH=arm CROSS_COMPILE=arm-linux-gnueabi- uImage
