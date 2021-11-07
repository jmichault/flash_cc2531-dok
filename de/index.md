---
komentoj_id: 1
lang: de
lang-niv: auto
lang-ref: 001-ĉefa-afero
layout: page
slug: 'Die Hauptsache!'
title: 'Die Hauptsache'
---

# [ _flash\_cc2531_ ](https://github.com/jmichault/flash_cc2531)
 [ _flash\_cc2531_ ](https://github.com/jmichault/flash_cc2531) ermöglicht es Ihnen, Ihren CC2531 USB-Stick Ihrer _Raspberry_, ohne dass _Arduino_ oder a _CC Debugger_programmieren können.  

## Voraussetzung
Sie benötigen entweder _Raspberry_ oder _Odroid-c2_.  
Sie benötigen, um den Debug-Port des Schlüssels mit den Ports _GPIO_ von _Raspberry_zu verbinden, z. B. ein Kabel _CC_ und vier Leitungen _Dupont_ (, siehe weiter unten).   
[ _WiringPi_ ](http://wiringpi.com/) muss installiert werden \(Wenn es nicht vorinstalliert ist, können Sie es normalerweise mit `sudo apt install wiringpi`)installieren, ansonsten siehe [die Stelle von _Gordon_ ](http://wiringpi.com/) oder [dieser alternativen Stelle](https://github.com/WiringPi/WiringPi) \).  
Schließlich benötigen Sie das Programm:

* Allgemeiner Koordinator _zigbee_ : [ Version 1.2 (empfohlen)](https://github.com/Koenkk/Z-Stack-firmware/raw/master/coordinator/Z-Stack_Home_1.2/bin/default/) oder [Version 3.0](https://github.com/Koenkk/Z-Stack-firmware/tree/master/coordinator/Z-Stack_3.0.x/bin)°)


* Oder Router _zigbee_ : [Router _zigbee_ 1,2](https://github.com/Koenkk/Z-Stack-firmware/tree/master/router/CC2531/bin)



Ich habe _flash\_cc2531_ auf _Raspberry Pi 3_ mit _raspbian_projiziert, aber bei anderen Modellen wurde über erfolgreiche Programmierung berichtet:

 * auf pi 4 benötigen sie version 2.52 von _wiringpi_ :  [install _wiringPi_ 2.52 von _Gordon_ ](http://wiringpi.com/wiringpi-updated-to-2-52-for-the-raspberry-pi-4b/)website


 * auf pi 1 und pi 2 benötigen Sie [, um andere Stifte](#uzi_aliajn_pinglojn)zu verwenden.



## Bereit

Laden Sie _flash\_cc2531_ auf Ihre _raspberry_ herunter:
```bash
git clone https://github.com/jmichault/flash_cc2531.git
```

Verbinden Sie die folgenden Stifte des violetten Ports an den GPO-Anschluss:
![](/public/raspberry-cc.png "disposition _raspberry_ et _CC_") 

|  

Das Pin-Layout _raspberry_ finden Sie hier: <https://pinout.xyz/>


Geben Sie dann den USB-Schlüssel in den Port ein.  

Download-Kabel _CC_ und 4 Zeilen _Dupont_ weibliche Weibchen ist ideal für diesen Zweck:
Foto des Schlüssels und der _raspberry_ ](https://github.com/jmichault/files/raw/master/Raspberry-CC2531.jpg)
Dies ist meine Lieblingsoption, aber wenn Sie kein Kabel _CC_ haben, können Sie auch die Kabel _Dupont_ auch direkt an der Taste freigeben: Siehe beispielsweise die Site [ _lemariva.com_ ](https://lemariva.com/blog/2019/08/zigbee-flashing-cc2531-using-raspberry-pi-without-cc-debugger) oder [ _notenoughtech.com_ ](https://notenoughtech.com/home-automation/flashing-cc2531-without-cc-debugger )


versuchen Sie dies:
```bash
cd flash_cc2531
./cc_chipid
```
Es muss zurückkehren:
```
  ID = b524.
```
(Der Wert kann unterschiedlich sein, wenn die Hardwareversion Ihres Schlüssels nicht mit meiner übereinstimmt).  
Wenn Sie 0000 oder ffff sehen, ist etwas falsch:

 * Überprüfen Sie zuerst Ihre Verkabelung.


 * Versuchen Sie dann eine höhere Basiszeit, zum Beispiel mit `./cc_chipid -m 100`oder `./cc_chipid -m 160` oder `./cc_chipid -m 300`.


 * Wenn dies nicht funktioniert, versuchen Sie es erneut mit `make`.



## Verwendung
So speichern Sie den Inhalt des Flash-Speichers in der Datei save.hex:
```bash
./cc_read save.hex
```
(dauert ungefähr 2 Minuten).  

So löschen Sie den Blitzer Speicher:
```bash
./cc_erase
```
**Hinweis:** Sie **müssen** vor dem Schreiben löschen (, es sei denn, Sie wissen wirklich, was Sie tun werden).

Programmieren der Datei _CC2531ZNP-Prod.hex_ am Schlüssel _CC2531_:
```bash
./cc_write CC2531ZNP-Prod.hex
```
(dauert ca. 3 Minuten).

<a id="uzi_aliajn_pinglojn"></a>

## Verwenden Sie andere Stifte

Alle Befehle akzeptieren die folgenden Argumente:

 * _-c_ Stift: Ändern Sie den Stift _DC_ (standardmäßig um 27)


 * _-d_ Stift: Ändern Sie den Stift _DD_ (standardmäßig 28)


 * _-r_ Stift: Ändern Sie den Stift _reset_ (standardmäßig um 24)


 * _-m_ : Ändern Sie standardmäßig den Verzögerungsmultiplikator und damit die Basiszeit (: automatische Anpassung)



Die verwendete Pin-Nummerierung ist die von _wiringPi_. Verwenden Sie `gpio readall` , um das Layout in Ihrer Spalte _Raspberry_ ( _wPi_ )anzuzeigen.

Wenn Sie beispielsweise die Stifte 3, 11 und 13 verwenden möchten:  
Verbinden Sie die folgenden Stifte des lila Ports an den Anschluss _GPIO_:

 1. Pin 1 ( _GND_ ) -> Pin 14 ( _GND_ )


 2. Pin 7 ( _reset_ ) -> Pin 3 ( _wPi 8, BCM2_ )


 3. Pin 3 ( _DC_ ) -> Pin 11 ( _wPi 0, BCM17_ )


 4. Pin 4 ( _DD_ ) -> Pin 13 ( _wPi 2, BCM27_ )



Und jetzt können Sie einen Identifizierer lesen, speichern, löschen und einen Blitzspeicher mit den folgenden Befehlen schreiben und schreiben:
```bash
./cc_chipid -r 8 -c 0 -d 2
./cc_read -r 8 -c 0 -d 2 save.hex
./cc_erase -r 8 -c 0 -d 2
./cc_write -r 8 -c 0 -d 2 CC2531ZNP-Prod.hex
```

Sie können auch die Standardwerte auf _CCDebugger.h_ ändern und die Programme mit `make`kompilieren.

## Was ist, wenn es nicht funktioniert?

1. Stoppen Sie alle anderen Programme.


2. Stellen Sie die Prozessorgeschwindigkeit vor dem Programmieren ein. Beispiel:



   ```bash
   sudo echo performance >/sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
   ```
3. Verwenden Sie die Option -m, um die verwendeten Zeitlimits zu erhöhen. Beispiel:



   ```bash
   ./cc_write -m 300 CC2531ZNP-Prod.hex
   ```
4. Kompilieren Sie das Programm erneut mit `make`.



5. Suchen Sie nach einer Lösung [in den Fragen, die bereits auf Github](https://github.com/jmichault/flash_cc2531/issues?q=is%3Aissue)gestellt wurden.



6. Stellen Sie Ihre eigene Frage zu [Github](https://github.com/jmichault/flash_cc2531/issues/new/choose).



7. Überprüfen Sie Ihren Ernährungsblock


    
   ```bash
   grep Under /var/log/kern.log
   ```
Wenn Sie viele Linien bekommen, müssen Sie den Ernährungsblock wechseln.  

## Ich möchte mehr als 15 Peripherie anschließen
Wir lesen an verschiedenen Orten, an denen der Schlüssel _CC2531_ nur 15 Maximalgeräte behandeln kann.   
Tatsächlich ist die Grenze für _CC2531_ viel höher.   
Beachten Sie auch, dass das Protokoll _zigbee_ die Anzahl der direkten Verbindungen auf die 32. Grenzung begrenzt.  

## Mein Schlüssel hat seine rote LED, die beleuchtet.
Es passiert, dass die wichtigsten Devergogramme, entweder aufgrund der von Parasiten geladenen Umwelt oder aufgrund schlechter Ernährung aufgrund der echten Nahrung.  

1. Überprüfen Sie Ihren Ernährungsblock


    
   ```bash
   grep Under /var/log/kern.log
   ```
Wenn Sie viele Linien bekommen, müssen Sie den Ernährungsblock wechseln.  

2. Holen Sie sich den Schlüssel zu störenden Materialien: Lautsprecher, Wi-Fi-Router, ...



3. Umprogrammieren Sie den Schlüssel


 


## Lizenz

Dieses Projekt ist unter der GPL v3 ( lizenziert, siehe _COPYING_ ).
