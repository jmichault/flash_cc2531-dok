---
komentoj_id: 1
lang: es
lang-niv: auto
lang-ref: 001-ĉefa-afero
layout: page
slug: '¡Lo esencial!'
title: 'Lo esencial'
---

# [ _flash\_cc2531_ ](https://github.com/jmichault/flash_cc2531)
 [ _flash\_cc2531_ ](https://github.com/jmichault/flash_cc2531) le permite programar su llave USB CC2531 desde su _Raspberry_, sin la necesidad de _Arduino_ o _CC Debugger_.

## Requisito previo
Necesita _Raspberry_ o _Odroid-c2_.  
Necesita qué conectar el puerto de depuración de la llave a los puertos _GPIO_ de _Raspberry_, por ejemplo, un cable _CC_ y cuatro líneas _Dupont_ (ver más).   
[ _WiringPi_ ](http://wiringpi.com/) debe instalarse \(si no está preinstalado, normalmente puede instalarlo con `sudo apt install wiringpi`); de lo contrario, consulte [el lugar de _Gordon_ ](http://wiringpi.com/) o [este lugar alternativo](https://github.com/WiringPi/WiringPi) \).  
Finalmente necesitas el programa:

* generalmente coordinador zigbee: [ versión 1.2 (recomendado)](https://github.com/Koenkk/Z-Stack-firmware/raw/master/coordinator/Z-Stack_Home_1.2/bin/default/) o [versión 3.0](https://github.com/Koenkk/Z-Stack-firmware/tree/master/coordinator/Z-Stack_3.0.x/bin)


* o enrutador zigbee: [enrutador zigbee 1.2](https://github.com/Koenkk/Z-Stack-firmware/tree/master/router/CC2531/bin)



Proyecté _flash\_cc2531_ en _Raspberry Pi 3_ con _raspbian_, pero se informó una programación exitosa en otros modelos:

 * en pi 4 necesitará la versión 2.52 de _wiringpi_ :  [instalar _wiringPi_ 2.52 de _Gordon_ ](http://wiringpi.com/wiringpi-updated-to-2-52-for-the-raspberry-pi-4b/)sitio web


 * en pi 1 y pi 2 necesitará [para usar otros pines](#uzi_aliajn_pinglojn).


 * sin embargo, probablemente deba configurar la opción de base de tiempo ( _"-m"_ ).



## Preparado

Descarga _flash\_cc2531_ a tu _raspberry_ :
```bash
git clone https://github.com/jmichault/flash_cc2531.git
```

Conecte los siguientes pines del puerto de depuración al puerto GPIO:

 1. pin 1 ( _GND_ ) -> pin 39 ( _GND_ )


 2. pin 7 ( _reset_ ) -> pin 35 ( _wPi 24, BCM19_ )


 3. pin 3 ( _DC_ ) -> pin 36 ( _wPi 27, BCM16_ )


 4. pin 4 ( _DD_ ) -> pin 38 ( _wPi 28, BCM20_ )



El diseño de los pines _raspberry_ está disponible aquí: <https://pinout.xyz/>

e inserte la llave USB en un puerto.

Cable de descarga _CC_ y 4 líneas _Dupont_ Hembra a Hembra son perfectos para este propósito:
![foto de la llave y la _raspberry_ ](https://github.com/jmichault/files/raw/master/Raspberry-CC2531.jpg))
Esta es mi opción favorita, pero si no tiene un cable _CC_ también puede soldar directamente los cables _Dupont_ en la llave: consulte, por ejemplo, el sitio web [ _lemariva.com_ ](https://lemariva.com/blog/2019/08/zigbee-flashing-cc2531-using-raspberry-pi-without-cc-debugger) o [ _notenoughtech.com_ ](https://notenoughtech.com/home-automation/flashing-cc2531-without-cc-debugger )


prueba esto:
```bash
cd flash_cc2531
./cc_chipid
```
Debe volver:
```
  ID = b524.
```
(el valor puede ser diferente si la versión de hardware de su llave no es la misma que la mía).  
Si ve 0000 o ffff algo falla:

 * Primero revise su cableado.


 * luego pruebe con un tiempo base más alto, por ejemplo con `./cc_chipid -m 100`, o `./cc_chipid -m 160` o `./cc_chipid -m 300`.


 * si nada de esto funciona, intente recompilar con `make`.



## uso
Para guardar el contenido de la memoria flash en el archivo save.hex:
```bash
./cc_read save.hex
```
(dura aproximadamente 1 minuto).

Para borrar la memoria flash:
```bash
./cc_erase
```
**Nota:** Usted **debe** borrar antes de escribir (a menos que realmente sepa lo que va a hacer).

Para programar el archivo _CC2531ZNP-Prod.hex_ en la tecla _CC2531_:
```bash
./cc_write CC2531ZNP-Prod.hex
```
(dura aproximadamente 3 minutos).

<a id="uzi_aliajn_pinglojn"></a>

## Usa otros pines

todos los comandos aceptan los siguientes argumentos:

 * _-c_ pin: cambia el pin _DC_ (por defecto 27)


 * _-d_ pin: cambia el pin _DD_ (por defecto 28)


 * _-r_ pin: cambia el pin _reset_ (por defecto 24)


 * _-m_ : cambia el multiplicador de retardo, y por lo tanto el tiempo base (por defecto: ajuste automático)



la numeración de pines utilizada es la de _wiringPi_. Utilice `gpio readall` para tener el diseño en su columna _Raspberry_ ( _wPi_ ).

Por ejemplo, si desea utilizar los pines 3, 11 y 13:  
Conecte los siguientes pines desde un puerto de depuración a una puerta _GPIO_:

 1. pin 1 ( _GND_ ) -> pin 14 ( _GND_ )


 2. pin 7 ( _reset_ ) -> pin 3 ( _wPi 8, BCM2_ )


 3. pin 3 ( _DC_ ) -> pin 11 ( _wPi 0, BCM17_ )


 4. pin 4 ( _DD_ ) -> pin 13 ( _wPi 2, BCM27_ )



y ahora puede leer ID, guardar, borrar y escribir memoria flash con los siguientes comandos:
```bash
./cc_chipid -r 8 -c 0 -d 2
./cc_read -r 8 -c 0 -d 2 save.hex
./cc_erase -r 8 -c 0 -d 2
./cc_write -r 8 -c 0 -d 2 CC2531ZNP-Prod.hex
```

También puede cambiar los valores predeterminados a _CCDebugger.h_ y compilar los programas con `make`.

## ¿y si no funciona?

1. detenga todos los demás programas.


2. establezca la velocidad del procesador antes de programar. Ejemplo:



   ```bash
   sudo echo performance >/sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
   ```
3. utilice la opción -m para aumentar los límites de tiempo utilizados. Ejemplo:



   ```bash
   ./cc_write -m 300 CC2531ZNP-Prod.hex
   ```
4. recompile el programa con `make`.



5. busque una solución [en las preguntas ya formuladas en github](https://github.com/jmichault/flash_cc2531/issues?q=is%3Aissue)



6. Haga su propia pregunta sobre [github](https://github.com/jmichault/flash_cc2531/issues/new/choose).



## Licencia

Este proyecto tiene la licencia GPL v3 ( ver _COPYING_ ).
