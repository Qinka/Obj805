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
 *   GPIO lower level header file
 *   
 **************************************************************************************
 */

#ifndef _GPIO_H_
#define _GPIO_H_

// headers
#include <asm/io.h>
#include <mach/platform.h>
#include "reinclude.h"
			
#ifdef _GPIO_C_			
#define GPIO_EXTERN__				
#define GPIO_EXPORT__(y) EXPORT_SYMBOL_GPL(y)	
#else					
#define GPIO_EXTERN__ extern			
#define GPIO_EXPORT__(y)				
#endif

// struct for gpio
struct bcm2835_gpio {
 u32 GPFSEL[6];
 u32 __reserved_1;
 u32 GPSET[2];
 u32 __reserved_2;
 u32 GPCLR[2];
 u32 __reserved_3;
 u32 GPLEV[2];
};

GPIO_EXTERN__ int set_gpio_function(struct bcm2835_gpio* gpio, int pin, int function);
GPIO_EXPORT__(set_gpio_function);
GPIO_EXTERN__ int set_gpio_val(struct bcm2835_gpio* gpio, int pin, int val);
GPIO_EXPORT__(set_gpio_val);
GPIO_EXTERN__ struct bcm2835_gpio* get_gpio_register(void);
GPIO_EXPORT__(get_gpio_register);
GPIO_EXTERN__ int get_gpio_val(struct bcm2835_gpio* gpio, int pin);
GPIO_EXPORT__(get_gpio_val);

// ERROR Information
#define GPIO_ERR_NULL 1

#endif // _GPIO_H_
