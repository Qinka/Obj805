/*************************************************************************************
 * 
 *   The driver for serial-gpio-extend (for output)
 *   This device uses shift registers, such as 74HC595, to extend gpio.
 *   For a normal device, we can use 3 pins to ``extend'' to 16 pins.
 *
 *   Copyright (C) Qinka 2017
 *   Licence: GPLv3+
 *   Maintainer: me@qinka.pro
 *   Stability: experimental
 *   Portability: just for raspberrypi(2B) (using BCM 2835)
 *
 *   GPIO Header file
 *   
 **************************************************************************************
 */


#include <mach/platform.h>
#include <linux/kernel.h>

#ifndef _GPIO_H_
#define _GPIO_H_


// struct for gpio

struct bcm2835_gpio_o {
  u32 GPFSEL[6];
  u32 __reserved_1;
  u32 GPSET[2];
  u32 __reserved_2;
  u32 GPCLR[2];
};

void set_gpio_function(struct bcm2835_gpio_o* gpio, int pin, int function);
void set_gpio_output_val(struct bcm2835_gpio_o* gpio, int pin, int val);

#endif // _GPIO_H_
