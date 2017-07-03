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

#define _SERIAL_GPIO_EXTEND_C_
#include "serial-gpio-extend.h"



// global variables
static struct serial_gpio_extend_output* sgeo_entry = NULL;
static struct dev_t sgeo_dev; // device
static int count;
static int sgeo_major = 0;
static int pins[3] = {0,0,0};
static int gpio_bits = 0;
// proc
static struct proc_dir_entry *sgeo_proc;


// tasklet to sync gpio
void sgeo_sync_worker(unsigned long ptr);
static struct tasklet_struct sgeo_sync_tl;

// allocate the sgeo entry
struct serial_gpio_extend_output* sgeo_entry_alloc() {
  struct serial_gpio_extend_output* entry;
  printk(KERN_INFO "SGEO: Entry allocate\n");
  entry = kmalloc(sizeof(struct serial_gpio_extend_output),GFP_KERNEL);
  if (sgeo_entry == NULL) {
    printk(KERN_ERR "SGEO: can not allocate memory\n");
    return NULL;
  }
  entry->data_pin = DATA_PIN(pins);
  entry->sync_pin = SYNC_PIN(pins);
  entry->clk_pin  = CLK_PIN(pins);
  if (gpio_bits)
    entry->gpio_bits = gpio_bits;
  else
    entry->gpio_bits = BITS_SIZE;
  entry->gpio_buffer = kmalloc(BUFFER_SIZE(entry->gpio_bits),GFP_KERNEL);
  sema_init(&entry->sem,1);
  entry->gpio = (struct bcm2835_gpio_o*)__io_address(GPIO_BASE);
  set_gpio_function(entry->gpio,entry->data_pin,0b001);
  set_gpio_function(entry->gpio,entry->sync_pin,0b001);
  set_gpio_function(entry->gpio,entry->clk_pin,0b001);
  set_gpio_output_val(entry->gpio,entry->data_pin,0);
  set_gpio_output_val(entry->gpio,entry->sync_pin,0);
  set_gpio_output_val(entry->gpio,entry->clk_pin,0);
  return entry;
}
    
    
// free sego entry
void sgeo_entry_free(struct serial_gpio_extend_output ** entry){
  printk(KERN_INFO "SEGO: free entry\n");
  if(*entry != NULL) {
    kfree((*entry)->gpio_buffer);
  }
  else
    printk(KERN_WARNING "SEGO: sego_entry is NULL\n");
  kfree(*entry);
  *entry = NULL;
}
    
// set up the value
void sgeo_set_value(struct serial_gpio_extend_output * entry,int pin,char val) {
  down_interruptible(&entry->sem);
  if(val == 0)
    entry->gpio_buffer[pin / 8] &= ~(1 << (pin % 8));
  else
    entry->gpio_buffer[pin /8 ] |=  (1 << (pin % 8));
  up(&entry->sem);
  tasklet_schedule(&sgeo_sync_tl);
}

// return the default of this module
struct serial_gpio_extend_output * sgeo_default_entry_open(){
  try_module_get(THIS_MODULE);
  return sgeo_entry;
}
// ``close''
void sgeo_default_entry_close(){
  module_put(THIS_MODULE);
}


// the worker for tasklet to send info.
void sgeo_sync_worker(unsigned long ptr) {
  struct serial_gpio_extend_output* entry = (struct serial_gpio_extend_output*) ptr;
  for(int i = 0; i < BUFFER_SIZE(entry->gpio_bits); ++i) {
    char * c = entry->gpio_buffer[i];
    char mask = 0b1;
    while(mask) {
      if(*c & mask)
	set_gpio_output_val(entry->gpio,entry->data_pin,1);
      else	
	set_gpio_output_val(entry->gpio,entry->data_pin,0);      
      set_gpio_output_val(entry->gpio,entry->clk_pin,1);
      ndelay(100);    
      set_gpio_output_val(entry->gpio,entry->clk_pin,0);
      mask <<= 1;
    }
  }
  set_gpio_output_val(entry->gpio,entry->sync_pin,1);
  ndelay(100);
  set_gpio_output_val(entry->gpio,entry->sync_pin,0);      
}


// for proc file
// open
int sgeo_proc_open(struct inode* inode,struct file *filp) {
  try_module_get(THIS_MODULE);
  return 0;
}
// close
int sgeo_proc_close(struct inode* inode, struct file *filp) {
  module_put(THIS_MODULE);
  return 0;
}
// read
int sgeo_proc_read(struct file *filp,char *buf,size_t count,loff_t* f_pos){
  int len = 0;
  int limit = count - 20;
  int k = *f_pos / 14;
  for(int i = k / 8; i < BUFFER_SIZE(sgeo_entry->gpio_bits) && len <= limit; ++i) {
    char * c = sgeo_entry->gpio_buffer[i];
    char mask = 0b1 << k % 8;
    while(mask) {
      if(*c & mask)
	len += sprintf(buf+len,"pin %4d:HIGH\n",k);
      else	
	len += sprintf(buf+len,"pin %4d: LOW\n",k);
      k++;
    }
  }
  *f_pos += len;
  return 0;
}


static struct file_operations sgeo_proc_fops = {
 open    : sgeo_proc_open,
 release : sgeo_proc_close,
 read    : sgeo_proc_read,
};

// init for module
static int serial_gpio_extend_init(void) {
  printk(KERN_INFO "SGE: start !\n");
  tasklet_init(&sgeo_sync_tl,sgeo_sync_worker,(unsigned long)sgeo_entry);
  sgeo_entry = sgeo_entry_alloc();
  sgeo_proc = proc_create_data("sge_output_pins",0444,NULL,&sgeo_proc_fops,"qinka");
  return 0;
}

// exit for module
static void  serial_gpio_extend_exit(void) {
  printk(KERN_INFO "SGE: exit !\n");
  remove_proc_entry("sge_output_pin",NULL);
  sgeo_entry_free(&sgeo_entry);
}


module_init(serial_gpio_extend_init);
module_exit(serial_gpio_extend_exit);

module_param(gpio_bits,int,S_IRUGO);
module_param_array(pins,int,3,S_IRUGO);

MODULE_AUTHOR("Qinka <me@qinka.pro>");
MODULE_LICENSE("GPL");
