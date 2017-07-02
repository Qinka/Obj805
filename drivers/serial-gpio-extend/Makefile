obj-m := seg.o
seg-objs := serial-gpio-extend.o gpio.o


KERNELBUILD := ~/rpi2/linux-rpi-4.4.y
ccflags-y := -std=gnu11

module: serial-gpio-extend.c gpio.c serial-gpio-extend.h gpio.h
	$(MAKE) ARCH=arm -C $(KERNELBUILD) M=$(shell pwd) modules CROSS_COMPILE=armv7-rpi2-linux-gnueabihf-

clean:
	rm -rf *.o *~ core .depend *.cmd *.ko *.mod.c *.tmp_versions

