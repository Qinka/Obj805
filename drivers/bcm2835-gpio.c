/*************************************************************************************
 * 
 *   The lower level for access the GPIO of Raspberry Pi (using BCM2835),
 *   This is tested with RaspberryPi model 2B .
 *
 *   Copyright (C) Qinka 2017
 *   Licence: GPLv3+
 *   Maintainer: me@qinka.pro
 *   Stability: experimental
 *   Portability: just for raspberrypi(2B) (using BCM 2835)
 *
 *   GPIO lower level source file
 *   
 **************************************************************************************
 */

#define _GPIO_C_
#include "bcm2835-gpio.h"


int set_gpio_function(struct bcm2835_gpio*gpio, int pin, int function) {
  if(gpio == NULL) {
    printk(KERN_WARNING "GPIO: gpio is NULL\n");
    goto gpio_is_null;
  }
  int reg_index = pin / 10;
  int bit = (pin % 10) *3;
  unsigned old = gpio->GPFSEL[reg_index];
  unsigned mask = 0b111 << bit;
  printk(KERN_DEBUG "GPIO: changing function of GPIO pin %d from %x to %x\n",pin, (old >> bit) & 0b111,function);
  gpio->GPFSEL[reg_index] = (old & ~mask) | ((function << bit) & mask);
  return 0;
 gpio_is_null:
  return - GPIO_ERR_NULL;
}

int set_gpio_val(struct bcm2835_gpio*gpio, int pin, int val) {
  if(gpio == NULL) {
    printk(KERN_WARNING "GPIO: gpio is NULL\n");
    goto gpio_is_null;
  }
  int pind = pin % 64;
  do_div(pind,32);
  if (val != 0)
    gpio->GPSET[pind] |= 1 << (pin % 32);
  else
    gpio->GPCLR[pind] &= 1 << (pin % 32);
  return 0;
 gpio_is_null:
  return - GPIO_ERR_NULL;
}

struct bcm2835_gpio* get_gpio_register(){
  return (struct bcm2835_gpio*)__io_address(GPIO_BASE);
}

int get_gpio_val(struct bcm2835_gpio* gpio, int pin){
  if(gpio == NULL) {
    printk(KERN_WARNING "GPIO: gpio is NULL\n");
    goto gpio_is_null;
  }
  int pind = pin % 64;
  do_div(pind,32);
  return (gpio->GPLEV[pind] & (1 << (pin % 32))) ? 1 : 0;
 gpio_is_null:
  return - GPIO_ERR_NULL;
}


static int gpio_init(void) {
  printk(KERN_INFO "GPIO: module load\n");
  return 0;
}

static void gpio_exit(void) {
  printk(KERN_INFO "GPIO: module exit\n");
}

module_init(gpio_init);
module_exit(gpio_exit);

MODULE_AUTHOR("Qinka <me@qinka.pro>");
MODULE_LICENSE("GPL");
