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
 *   GPIO source file
 *   
 **************************************************************************************
 */

#define _GPIO_C_

#include "gpio.h"



void set_gpio_function(struct bcm2835_gpio_o*gpio, int pin, int function) {
  int reg_index = pin / 10;
  int bit = (pin % 10) *3;
  unsigned old = gpio->GPFSEL[reg_index];
  unsigned mask = 0b111 << bit;
  printk(KERN_DEBUG "GPIO: changing function of GPIO pin %d from %x to %x\n",pin, (old >> bit) & 0b111,function);
  gpio->GPFSEL[reg_index] = (old & ~mask) | ((function << bit) & mask);
}

void set_gpio_output_val(struct bcm2835_gpio_o*gpio, int pin, int val) {
  if (val != 0)
    gpio->GPSET[pin / 32] |= 1 << (pin % 32);
  else
    gpio->GPSET[pin / 32] &= ~(1 << (pin % 32));
}
