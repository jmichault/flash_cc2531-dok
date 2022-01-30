---
komentoj_id: 1
lang: en
lang-niv: auto
lang-ref: 001-ĉefa-afero
layout: page
slug: 'The main thing!'
title: 'The main thing'
---

# [ _flash\_cc2531_ ](https://github.com/jmichault/flash_cc2531)
 [ _flash\_cc2531_ ](https://github.com/jmichault/flash_cc2531) enables you to program your CC2531 USB stick of your _Raspberry_, without the need for _Arduino_ or A _CC Debugger_.  

## Prerequisite
You need either _Raspberry_ or _Odroid-c2_.  
You need what to connect the debug port of the key to the _GPIO_ ports of _Raspberry_, for example one cable _CC_ and four lines _Dupont_ (see further).   
[ _WiringPi_ ](http://wiringpi.com/) must be installed \(if it's not pre-installed, you can usually install it with `sudo apt install wiringpi`), otherwise see [the site of _Gordon_ ](http://wiringpi.com/) or [this alternative site](https://github.com/WiringPi/WiringPi) \).  
Finally you need the software:

* General coordinator _zigbee_ : [ Version 1.2 (Recommended)](https://github.com/Koenkk/Z-Stack-firmware/raw/master/coordinator/Z-Stack_Home_1.2/bin/default/) or [version 3.0](https://github.com/Koenkk/Z-Stack-firmware/tree/master/coordinator/Z-Stack_3.0.x/bin)


* Or _zigbee_ router: [router _zigbee_ 1.2](https://github.com/Koenkk/Z-Stack-firmware/tree/master/router/CC2531/bin)



I've created _flash\_cc2531_ on _Raspberry Pi 3_ with _raspbian_, but successful programming was reported on other models:

 * on pi 4 you will need version 2.52 of _wiringpi_ :  [install _wiringPi_ 2.52 of _Gordon_ ](http://wiringpi.com/wiringpi-updated-to-2-52-for-the-raspberry-pi-4b/)website


 * on pi 1 and pi 2 you will need [to use other pins](#uzi_aliajn_pinglojn).



## Preparation

Download _flash\_cc2531_ to your _raspberry_ :
```bash
git clone https://github.com/jmichault/flash_cc2531.git
```

Connect the following pins of the debug port to the GPIO port:
![](/public/raspberry-cc.png "disposition _raspberry_ et _CC_") 

|   _GPIO_ pin         | _CC_ pin   
 | ---------------------- | ------------ |  
 | 39  (  _GND_  )            | 1  (  _GND_  )   | 	 
 | 36  (  _wPi 27, BCM16_  )  | 3  (  _DC_  )    |  
 | 38  (  _wPi 28, BCM20_  )  | 4  (  _DD_  )    |  
 | 35  (  _wPi 24, BCM19_  )  | 7  (  _reset_  ) |  

The pin layout of _raspberry_ is available here: <https://pinout.xyz/>


Then enter the USB key into port.    
 Note: If you do not want to insert the key in a USB port, you can instead connect the pin  _CC_  9 to one pin  _3,3v_  of  _raspberry_  ( Pin 1 or 17 ).  

Download-cable _CC_ and 4 _Dupont_ lines female to female are perfect for this purpose:
![stick and _raspberry_ ](https://github.com/jmichault/files/raw/master/Raspberry-CC2531.jpg)
This is my favorite option, but if you don’t have a cable CC you can also directly solder the cables Dupont on the key: see for example the website [ _lemariva.com_ ](https://lemariva.com/blog/2019/08/zigbee-flashing-cc2531-using-raspberry-pi-without-cc-debugger) or [ _notenoughtech.com_ ](https://notenoughtech.com/home-automation/flashing-cc2531-without-cc-debugger )


try this:
```bash
cd flash_cc2531
./cc_chipid
```
It must return:
```
  ID = b524.
```
(the value may be different if the hardware version of your key is not the same as mine).  
If you see 0000 or ffff something is incorrect:

 * first check your wiring.


 * then try a higher base time, for example with `./cc_chipid -m 100`, or `./cc_chipid -m 160` or `./cc_chipid -m 300`.


 * if none of this works, try recompiling with `make`.



## usage
To save the contents of the flash memory to the save.hex file:
```bash
./cc_read save.hex
```
(takes about 2 minutes).  

To erase flash memory:
```bash
./cc_erase
```
**Note:** You **must** delete before writing (unless you really know what you are going to do).

To program the file _CC2531ZNP-Prod.hex_ on the key _CC2531_:
```bash
./cc_write CC2531ZNP-Prod.hex
```
(lasts about 3 minutes).

<a id="uzi_aliajn_pinglojn"></a>

## Use other pins

all commands accept the following arguments:

 * _-c_ pin: change the pin _DC_ (by default 27)


 * _-d_ pin: change the pin _DD_ (by default 28)


 * _-r_ pin: change the pin _reset_ (by default 24)


 * _-m_ : change the delay multiplier, and therefore the base time (by default: automatic adjustment)



the pin numbering used is that of _wiringPi_. Use `gpio readall` to have the layout in your _Raspberry_ (column _wPi_ ).

For example, if you want to use pins 3, 11 and 13:  
Connect the following pins of purifying port to port  _GPIO_: 

 1. pin 1 ( _GND_ ) -> pin 14 ( _GND_ )


 2. pin 7 ( _reset_ ) -> pin 3 ( _wPi 8, BCM2_ )


 3. pin 3 ( _DC_ ) -> pin 11 ( _wPi 0, BCM17_ )


 4. pin 4 ( _DD_ ) -> pin 13 ( _wPi 2, BCM27_ )



And now you can read an identifier, save, delete and write a lightning memory with the following commands:
```bash
./cc_chipid -r 8 -c 0 -d 2
./cc_read -r 8 -c 0 -d 2 save.hex
./cc_erase -r 8 -c 0 -d 2
./cc_write -r 8 -c 0 -d 2 CC2531ZNP-Prod.hex
```

## what if it doesn't work?

1. stop all other programs.


2. set the processor speed before programming. Example:



   ```bash
   sudo echo performance >/sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
   ```
3. use the -m option to increase the time limits used. Example:



   ```bash
   ./cc_write -m 300 CC2531ZNP-Prod.hex
   ```
4. recompile the program with `make`.



5. look for a solution [in the questions already asked on github](https://github.com/jmichault/flash_cc2531/issues?q=is%3Aissue)



6. Ask your own question about [github](https://github.com/jmichault/flash_cc2531/issues/new/choose).



7. Check your nutrition block 


    
   ```bash
   grep Under /var/log/kern.log
   ```
If you get a lot of lines then you have to change nutrition block.  

## I want to connect more than 15 periphery
We read in different locations that the key  _CC2531_  can only handle 15 maximum appliances.    
 In fact, the standard firmware of this key has a limit of 15 direct links. But if one of these connections is  _zigbee_  router  ( and most devices work as a router, that is, for example, the case of  _Philips Hue_  bulbs and  _Ikea TRÅDFRI_  bulb ), then the  _CC2531_  can manage the Devices behind this router, and those behind the router connected to this router ...   
In fact, the limit for the  _CC2531_  is much higher. And if one day you exceed more than 50 devices on your  _zigbee_  Network, investing in a more expensive coordinator will be just a small part of your budget.   
Also note that the protocol  _zigbee_  limits the number of direct links to 32th. Regardless of your coordinator  _zigbee_, it will not be possible to connect to more than 32 peripherals.  

## My key has its red LED that illuminates.
It happens that the key deprograms, either due to the environment loaded by parasites or due to poor nutrition.  

1. Check your nutrition block 


    
   ```bash
   grep Under /var/log/kern.log
   ```
If you get a lot of lines then you have to change nutrition block.  

2. Get away the key to disturbing materials: speakers, Wi-Fi router, ...



3. Reprogram the key


 


## License

This project is licensed under the GPL v3 ( see _COPYING_ ).
