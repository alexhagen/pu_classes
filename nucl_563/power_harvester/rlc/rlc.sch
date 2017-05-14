EESchema Schematic File Version 2
LIBS:power
LIBS:device
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
L R R?
U 1 1 58FF733E
P 3950 3450
F 0 "R?" V 4030 3450 50  0000 C CNN
F 1 "R" V 3950 3450 50  0000 C CNN
F 2 "" V 3880 3450 50  0000 C CNN
F 3 "" H 3950 3450 50  0000 C CNN
	1    3950 3450
	1    0    0    -1  
$EndComp
$Comp
L INDUCTOR L?
U 1 1 58FF73D7
P 4450 3250
F 0 "L?" V 4400 3250 50  0000 C CNN
F 1 "INDUCTOR" V 4550 3250 50  0000 C CNN
F 2 "" H 4450 3250 50  0000 C CNN
F 3 "" H 4450 3250 50  0000 C CNN
	1    4450 3250
	0    1    1    0   
$EndComp
$Comp
L C C?
U 1 1 58FF7602
P 5150 3250
F 0 "C?" H 5175 3350 50  0000 L CNN
F 1 "C" H 5175 3150 50  0000 L CNN
F 2 "" H 5188 3100 50  0000 C CNN
F 3 "" H 5150 3250 50  0000 C CNN
	1    5150 3250
	0    1    1    0   
$EndComp
$Comp
L GND #PWR?
U 1 1 58FF7682
P 5500 4000
F 0 "#PWR?" H 5500 3750 50  0001 C CNN
F 1 "GND" H 5500 3850 50  0000 C CNN
F 2 "" H 5500 4000 50  0000 C CNN
F 3 "" H 5500 4000 50  0000 C CNN
	1    5500 4000
	1    0    0    -1  
$EndComp
Wire Wire Line
	3950 3300 3950 3250
Wire Wire Line
	3950 3250 4150 3250
Wire Wire Line
	4750 3250 5000 3250
Wire Wire Line
	5300 3250 5500 3250
Wire Wire Line
	5500 3250 5500 4000
$Comp
L Battery BT?
U 1 1 58FF76B7
P 3950 3800
F 0 "BT?" H 4050 3850 50  0000 L CNN
F 1 "Battery" H 4050 3750 50  0000 L CNN
F 2 "" V 3950 3840 50  0000 C CNN
F 3 "" V 3950 3840 50  0000 C CNN
	1    3950 3800
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR?
U 1 1 58FF7740
P 3950 4000
F 0 "#PWR?" H 3950 3750 50  0001 C CNN
F 1 "GND" H 3950 3850 50  0000 C CNN
F 2 "" H 3950 4000 50  0000 C CNN
F 3 "" H 3950 4000 50  0000 C CNN
	1    3950 4000
	1    0    0    -1  
$EndComp
Wire Wire Line
	3950 3950 3950 4000
Wire Wire Line
	3950 3650 3950 3600
$EndSCHEMATC
