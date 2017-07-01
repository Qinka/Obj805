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
 *   source file
 *   
 **************************************************************************************
 */



#include "serial-gpio-extend.h"



// global variables
static struct serial_gpio_extend_output* sgeo_entry = NULL;
static struct dev_t sgeo_dev; // device
static int count;
static int sgeo_major = 0;
static int pins[3] = {0,0,0};
static int gpio_bits = 0;


// open operation
static int sgeo_open(struct inode *inode, struct file* filp) {
  printk(KERN_INFO "SGEO: Open, %d\n",count);
  if(sqeo_entry == NULL) {
    if (count == 0)
      printk(KERN_WARNING "SGEO: count is not zero, but sqeo_entry is NULL\n"); 
    sgeo_entry = kmalloc(sizeof(struct serial_gpio_extend_outpu),GFP_KERNEL);
    if (sgeo_entry == NULL) {
      printk(KERN_ERR "SGEO: can not allocate memory\n");
      return -ENOMEM;
    }
    sgeo_entry->data_pin = DATA_PIN(pins);
    sgeo_entry->sync_pin = SYNC_PIN(pins);
    sgeo_entry->clk_pin  = CLK_PIN(pins);
    if (gpio_bits)
      sgeo_entry->gpio_bits = gpio_bits;
    else
      sgeo_entry->gpio_bits = BITS_SIZE;
    sgeo_entry->dev_no = inode->i_rdev;
    sgeo_entry->gpio_buffer = kmalloc(BUFFER_SZIE(sgeo_entry->gpio_bits),GFP_KERNEL);
    init_rwsem(sgeo_entry->sem);
    sgeo_entry->gpio = (struct bcm2835_gpio_o*)__io_address(GPIO_BASE);
    set_gpio_function(sgeo_entry->gpio,sgeo_entry->data_pin,0b001);
    set_gpio_function(sgeo_entry->gpio,sgeo_entry->sync_pin,0b001);
    set_gpio_function(sgeo_entry->gpio,sgeo_entry->clk_pin,0b001);
    set_gpio_output_val(sgeo_entry->gpi,sgeo_entry->data_pin,1);
    set_gpio_output_val(sgeo_entry->gpi,sgeo_entry->sync_pin,1);
    set_gpio_output_val(sgeo_entry->gpi,sgeo_entry->clk_pin,1);
    sgeo_entry->cdev = inode->i_cdev;
    file->private_data = sgeo_entry;
  }
  try_module_get(THIS_MODULE);
  ++count;
  return 0;
}
    
    
// close operation
static int sgeo_close(struct inode *inode, struct file *filp){
  -- count;
  printk(KERN_INFO "SEGO: Close, %d\n",count);
  if(count == 0) {
    if(sego_entry != NULL) {
      kfree(sego_entry->gpio_buffer);
      gpio_free(sego_entry->gpio);
    }
    else
      printk(KERN_WARNING "SEGO: sego_entry is NULL\n");
    sego_entry = NULL;
  }
  module_put(THIS_MODULE);
  return 0;
}
    
   
