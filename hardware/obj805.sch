EESchema Schematic File Version 2
LIBS:power
LIBS:device
LIBS:switches
LIBS:relays
LIBS:motors
LIBS:transistors
LIBS:conn
LIBS:linear
LIBS:regul
LIBS:74xx
LIBS:cmos4000
LIBS:adc-dac
LIBS:memory
LIBS:xilinx
LIBS:microcontrollers
LIBS:dsp
LIBS:microchip
LIBS:analog_switches
LIBS:motorola
LIBS:texas
LIBS:intel
LIBS:audio
LIBS:interface
LIBS:digital-audio
LIBS:philips
LIBS:display
LIBS:cypress
LIBS:siliconi
LIBS:opto
LIBS:atmel
LIBS:contrib
LIBS:valves
LIBS:l293d
LIBS:obj805-cache
EELAYER 25 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 1 1
Title ""
Date ""
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L Conn_02x20_Odd_Even J0
U 1 1 5A051E59
P 1050 1800
F 0 "J0" H 1100 2800 50  0000 C CNN
F 1 "Conn_with_rapi" H 1100 700 50  0000 C CNN
F 2 "Pin_Headers:Pin_Header_Straight_2x20_Pitch2.54mm" H 1050 1800 50  0001 C CNN
F 3 "" H 1050 1800 50  0001 C CNN
	1    1050 1800
	1    0    0    -1  
$EndComp
$Comp
L Jack-DC P0
U 1 1 5A44CDCB
P 7300 2300
F 0 "P0" H 7300 2510 50  0000 C CNN
F 1 "Jack-DC" H 7300 2125 50  0000 C CNN
F 2 "Connectors:JACK_ALIM" H 7350 2260 50  0001 C CNN
F 3 "" H 7350 2260 50  0001 C CNN
	1    7300 2300
	1    0    0    -1  
$EndComp
$Comp
L Conn_01x02 F0
U 1 1 5A44CE0A
P 6500 1150
F 0 "F0" H 6500 1250 50  0000 C CNN
F 1 "Conn_01x02" H 6500 950 50  0000 C CNN
F 2 "Pin_Headers:Pin_Header_Straight_1x02_Pitch2.54mm" H 6500 1150 50  0001 C CNN
F 3 "" H 6500 1150 50  0001 C CNN
	1    6500 1150
	1    0    0    -1  
$EndComp
Wire Wire Line
	7600 2750 2150 2750
Wire Wire Line
	2150 2750 2150 1100
Wire Wire Line
	2150 1100 1350 1100
Wire Wire Line
	2300 2600 2300 900 
Wire Wire Line
	2300 900  1350 900 
Wire Wire Line
	2850 1500 1950 1500
Wire Wire Line
	2850 1700 2700 1700
Wire Wire Line
	2700 1700 2700 1150
Wire Wire Line
	2700 1150 6300 1150
Wire Wire Line
	6300 1250 4700 1250
Wire Wire Line
	4700 1250 4700 2750
Connection ~ 3750 2750
Wire Wire Line
	3200 2500 6350 2500
Wire Wire Line
	6350 2500 6350 1950
Wire Wire Line
	7600 2200 7600 1950
Wire Wire Line
	7600 1950 6350 1950
Wire Wire Line
	7600 2300 7600 2750
Connection ~ 7600 2400
Connection ~ 4700 2750
Wire Wire Line
	1950 1500 1950 700 
Wire Wire Line
	1950 700  700  700 
Wire Wire Line
	700  700  700  1200
Wire Wire Line
	700  1200 850  1200
Wire Wire Line
	3200 2500 3200 2400
Wire Wire Line
	3350 2400 3350 2600
Connection ~ 3350 2600
Wire Wire Line
	3350 2600 2300 2600
Wire Wire Line
	3650 2400 3950 2400
Connection ~ 3750 2400
Connection ~ 3850 2400
Wire Wire Line
	3750 2400 3750 2750
$Comp
L L293D U1
U 1 1 5A44E1F5
P 3600 1700
F 0 "U1" H 3600 2200 60  0000 C CNN
F 1 "L293D" H 4350 1250 60  0000 C CNN
F 2 "l293d:L293D" H 3600 1700 60  0001 C CNN
F 3 "" H 3600 1700 60  0001 C CNN
	1    3600 1700
	1    0    0    -1  
$EndComp
Wire Wire Line
	1350 1100 1350 1150
Wire Wire Line
	1350 1150 750  1150
Wire Wire Line
	750  1150 750  2800
Wire Wire Line
	750  1300 850  1300
Wire Wire Line
	1350 1500 1400 1500
Wire Wire Line
	1400 1100 1400 2500
Connection ~ 1400 1100
Wire Wire Line
	1400 1800 1350 1800
Connection ~ 1400 1500
Wire Wire Line
	1400 2300 1350 2300
Connection ~ 1400 1800
Wire Wire Line
	1400 2500 1350 2500
Connection ~ 1400 2300
Wire Wire Line
	750  2100 850  2100
Connection ~ 750  1300
Wire Wire Line
	750  2800 850  2800
Connection ~ 750  2100
Wire Wire Line
	1350 900  1350 1000
Wire Wire Line
	2850 1600 1650 1600
Wire Wire Line
	1650 1600 1650 3100
Wire Wire Line
	1650 3100 650  3100
Wire Wire Line
	650  3100 650  2600
Wire Wire Line
	650  2600 850  2600
$EndSCHEMATC
