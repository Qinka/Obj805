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
 *   Header file
 *   
 **************************************************************************************
 */

#ifndef _SERIAL_GPIO_EXTEND_H_
#define _SERIAL_GPIO_EXTEND_H_

// headers
#include <linux/cdev.h>
#include <linux/semaphore.h>
#ifdef _SERIAL_GPIO_EXTEND_C_
#include <linux/init.h>
#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/slab.h>
#include <linux/errno.h>
#include <linux/types.h>
#include <mach/platform.h>
#include <asm/io.h>
#include <linux/delay.h>
#include <linux/proc_fs.h>
#include <linux/interrupt.h>
#include "gpio.h"
#endif // _SERIAL_GPIO_EXTEND_C_


// default & configure
/* default bits
 */
#define BITS_SIZE (8)
/* how many byte need to hold all bits
 */
#define BUFFER_SIZE(b) ((b+7) / 8)
/* get the pins
 */
#define DATA_PIN(p) (p[0])
#define SYNC_PIN(p) (p[1])
#define CLK_PIN(p)  (p[2])


// struct for serial gpio extend
struct serial_gpio_extend_output {
  /* data pin is used to translate the single bit
   * for a byte 7 - - - - - - 0
   *                          |
   *                          first bit
   */
  int   data_pin;
  /* sync pin is used to output what is in the registers
   * after translated all bits, this bit should be high for a moment(then be low).
   */
  int   sync_pin;
  /* clk signal
   */
  int   clk_pin;
  /* how many bit the hardware has
   */
  int   gpio_bits;
  /* buffer for char(8bits)
   */
  char* gpio_buffer;
  /* the semaphore
   */
  struct semaphore sem;
  /* the gpio chip for raspberrypi 2b
   */
  struct bcm2835_gpio_o *gpio;
};

#ifdef _SERIAL_GPIO_EXTEND_C_
struct serial_gpio_extend_output* sgeo_entry_alloc(void);
void sgeo_entry_free(struct serial_gpio_extend_output **);
#endif // _SERIAL_GPIO_EXTEND_C_


#ifdef _SERIAL_GPIO_EXTEND_C_
void sgeo_set_value(struct serial_gpio_extend_output * entry,int pin,char val);
EXPORT_SYMBOL_GPL(sgeo_set_value);
struct serial_gpio_extend_output* sgeo_default_entry_open(void);
EXPORT_SYMBOL_GPL(sgeo_default_entry_open);
void sgeo_default_entry_close(void);
EXPORT_SYMBOL_GPL(sgeo_default_entry_close);
#else
extern int sgeo_set_value(struct serial_gpio_extend_output * entry,int pin,char val);
extern struct serial_gpio_extend_output * sgeo_default_entry_open(void);
extern void sgeo_default_entry_close(void);
#endif // _SERIAL_GPIO_EXTEND_C_

#endif // _SERIAL_GPIO_EXTEND_H_
