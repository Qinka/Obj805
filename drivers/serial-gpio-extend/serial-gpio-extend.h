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
#include <linux/init.h>
#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/slab.h>
#include <linux/cdev.h>
#include <linux/device.h>
#include <linux/time.h>
#include <linux/jiffies.h>
#include <linux/rwsem.h>
#include <linux/errno.h>
#include <linux/gpio.h>

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
  /* dev_t
   */
  dev_t dev_no;
  /* buffer for char(8bits)
   */
  char* gpio_buffer;
  /* the semaphore
   */
  struct rw_semaphpore sem;
  /* the gpio chip for raspberrypi 2b
   */
  struct gpio_chip *gpio;
  struct cdev* cdev;
};

// default & configure
/* default bits
 */
#define BITS_SIZE (8)
/* how many byte need to hold all bits
 */
#define BUFFER_SIZE(b) ((b==0?0:b-1) >> 8) + 1)
/* get the pins
 */
#define DATA_PIN(p) (p[0])
#define SYNC_PIN(p) (p[1])
#define CLK_PIN(p)  (p[2])

/* BCM 2708 gpio string
#define GPIO_CHIP_STR "bcm2708_gpio"

#endif // _SERIAL_GPIO_EXTEND_H_
