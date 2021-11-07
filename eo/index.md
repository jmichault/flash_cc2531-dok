---
komentoj_id: 1
lang: eo
lang-niv: homa
lang-ref: 001-ĉefa-afero
layout: page
slug: 'La ĉefa afero!'
title: 'La ĉefa afero'
---

# [ _flash\_cc2531_ ](https://github.com/jmichault/flash_cc2531)
 [ _flash\_cc2531_ ](https://github.com/jmichault/flash_cc2531) ebligas al vi programi vian CC2531 USB-bastonon de via _Raspberry_, sen la bezono de _Arduino_ aŭ a _CC Debugger_. 
Ĝi ankaŭ povas programi CC2530-ŝlosilon. 

## Antaŭkondiĉo
Vi bezonas aŭ _Raspberry_ aŭ _Odroid-c2_.  
Vi bezonas kion por konekti la elpurigan havenon de la ŝlosilo al la havenoj _GPIO_ de _Raspberry_, ekzemple unu kablo _CC_ kaj kvar linioj _Dupont_ (vidu plu).   
[ _WiringPi_ ](http://wiringpi.com/) devas esti instalita \(se ĝi ne estas antaŭinstalita, vi kutime povas instali ĝin per `sudo apt install wiringpi`), alie vidu [la retejon de _Gordon_ ](http://wiringpi.com/) aŭ [ĉi tiun alternativan retejon](https://github.com/WiringPi/WiringPi) \).  
Fine vi bezonas la programon:

* Enerale kunordiganto _zigbee_ : [ Versio 1.2 (rekomendita)](https://github.com/Koenkk/Z-Stack-firmware/raw/master/coordinator/Z-Stack_Home_1.2/bin/default/) aŭ [versio 3.0](https://github.com/Koenkk/Z-Stack-firmware/tree/master/coordinator/Z-Stack_3.0.x/bin)

* Aŭ enkursigilo _zigbee_ : [enkursigilo _zigbee_ 1.2](https://github.com/Koenkk/Z-Stack-firmware/tree/master/router/CC2531/bin)


Mi projektis _flash\_cc2531_ sur _Raspberry Pi 3_ kun _raspbian_, sed sukcesa programado estis raportita pri aliaj modeloj:

 * sur pi 4 vi bezonos version 2.52 de _wiringpi_ :  [instalu _wiringPi_ 2.52 de _Gordon_ ](http://wiringpi.com/wiringpi-updated-to-2-52-for-the-raspberry-pi-4b/)retejo

 * sur pi 1 kaj pi 2 vi bezonos [uzi aliajn pinglojn](#uzi_aliajn_pinglojn).


## Preparado

Elŝutu _flash\_cc2531_ al via _raspberry_ :
```bash
git clone https://github.com/jmichault/flash_cc2531.git
```

Konektu la sekvajn pinglojn de la elpuriga haveno al la GPIO-haveno:
![](/public/raspberry-cc.png "disposition _raspberry_ et _CC_") 

| pinglo de _GPIO_          | pinglo de _CC_  |
| ---------------------- | ------------ | 
| 39 ( _GND_ )           | 1 ( _GND_ )  |	
| 36 ( _wPi 27, BCM16_ ) | 3 ( _DC_ )   | 
| 38 ( _wPi 28, BCM20_ ) | 4 ( _DD_ )   | 
| 35 ( _wPi 24, BCM19_ ) | 7 ( _reset_ )| 

La pinglo-aranĝo de _raspberry_ haveblas ĉi tie: <https://pinout.xyz/>


Tiam enmetu la USB-ŝlosilon en havenon.   
Noto: Se vi ne volas enmeti la ŝlosilon en USB-havenon, vi povas anstataŭe konekti la pinglo _CC_ 9 al una pinglo _3,3v_ de _raspberry_ (pinglo 1 aŭ 17). 

Elŝuti-kablo _CC_ kaj 4 linioj _Dupont_ Ino al Ino estas perfektaj por ĉi tiu celo:
![foto de la ŝlosilo kaj la _raspberry_ ](https://github.com/jmichault/files/raw/master/Raspberry-CC2531.jpg)
Ĉi tiu estas mia plej ŝatata opcio, sed se vi ne havas kablon _CC_ vi ankaŭ povas rekte luti la kablojn _Dupont_ sur la ŝlosilo: vidu ekzemple la retejon [ _lemariva.com_ ](https://lemariva.com/blog/2019/08/zigbee-flashing-cc2531-using-raspberry-pi-without-cc-debugger) aŭ [ _notenoughtech.com_ ](https://notenoughtech.com/home-automation/flashing-cc2531-without-cc-debugger )


provu per ĉi tio:
```bash
cd flash_cc2531
./cc_chipid
```
Ĝi devas reveni:
```
  ID = b524.
```
(la valoro povas esti malsama se la aparatara versio de via ŝlosilo ne samas kun la mia).  
Se vi vidas 0000 aŭ ffff io estas malĝusta:

 * unue kontrolu vian kabligon.

 * tiam provu pli altan bazan tempon, ekzemple kun `./cc_chipid -m 100`, aŭ `./cc_chipid -m 160` aŭ `./cc_chipid -m 300`.

 * se neniu el tio funkcias, provu rekompili kun `make`.


## uzado
Por konservi la enhavon de la fulmmemoro en la dosiero save.hex:
```bash
./cc_read save.hex
```
(prenas ĉirkaŭ 2 minutojn). 

Por forviŝi fulmmemoron:
```bash
./cc_erase
```
**Noto:** Vi **devas** forviŝi antaŭ skribado (krom se vi vere scias, kion vi faros).

Por programi la dosieron _CC2531ZNP-Prod.hex_ sur la ŝlosilo _CC2531_:
```bash
./cc_write CC2531ZNP-Prod.hex
```
(daŭras ĉirkaŭ 3 minutojn).

<a id="uzi_aliajn_pinglojn"></a>
## Uzi aliajn pinglojn

ĉiuj ordonoj akceptas la jenajn argumentojn:

 * _-c_ pinglo: ŝanĝu la pinglon _DC_ (defaŭlte 27)

 * _-d_ pinglo: ŝanĝu la pinglon _DD_ (defaŭlte 28)

 * _-r_ pinglo: ŝanĝu la pinglon _reset_ (defaŭlte 24)

 * _-m_ : ŝanĝu la prokrastan multiplikaton, kaj do la bazan tempon (defaŭlte: aŭtomata ĝustigo)


la pinglonumerado uzata estas tiu de _wiringPi_. Uzu `gpio readall` por havi la aranĝon en via _Raspberry_ (kolumno _wPi_ ).

Ekzemple, se vi volas uzi pinglojn 3, 11 kaj 13:  
Konekti la jenajn pinglojn de elpuriga haveno al haveno _GPIO_:

 1. pinglo 1 ( _GND_ ) -> pinglo 14 ( _GND_ )

 2. pinglo 7 ( _reset_ ) -> pinglo 3 ( _wPi 8, BCM2_ )

 3. pinglo 3 ( _DC_ ) -> pinglo 11 ( _wPi 0, BCM17_ )

 4. pinglo 4 ( _DD_ ) -> pinglo 13 ( _wPi 2, BCM27_ )


kaj nun vi povas legi identigilon, konservi, forviŝi kaj skribi fulmmemoron per la jenaj komandoj:
```bash
./cc_chipid -r 8 -c 0 -d 2
./cc_read -r 8 -c 0 -d 2 save.hex
./cc_erase -r 8 -c 0 -d 2
./cc_write -r 8 -c 0 -d 2 CC2531ZNP-Prod.hex
```

Vi ankaŭ povas ŝanĝi la defaŭltajn valorojn en _CCDebugger.h_ kaj kompili la programojn per `make`.

## kio se ĝi ne funkcias?

1. ĉesu ĉiujn aliajn programojn.

2. agordu la rapidon de la procesoro antaŭ programado. Ekzemplo:


   ```bash
   sudo echo performance >/sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
   ```
3. uzu la opcion -m por pliigi la uzatajn tempolimojn. Ekzemplo:


   ```bash
   ./cc_write -m 300 CC2531ZNP-Prod.hex
   ```
4. rekompili la programon per `make`.


5. serĉu solvon [en la demandoj jam faritaj ĉe github](https://github.com/jmichault/flash_cc2531/issues?q=is%3Aissue)


6. Demandu vian propran demandon pri [github](https://github.com/jmichault/flash_cc2531/issues/new/choose).


7. Kontrolu vian nutroblokon

    
   ```bash
   grep Under /var/log/kern.log
   ```
Se vi ricevas multajn liniojn, tiam vi devas ŝanĝi nutroblokon. 

## Mi volas konekti pli ol 15 periferiojn
Ni legas en diversaj lokoj, kiujn la ŝlosilo _CC2531_ nur povas pritrakti 15 maksimumajn aparatojn.   
Fakte la normo firmware de ĉi tiu ŝlosilo havas limon de 15 rektaj ligoj. Sed se unu el ĉi tiuj konektoj estas _zigbee_ enkursigilo (kaj plej multaj aparatoj funkcias kiel enkursigilo, tio estas ekzemple la kazo de _Philips Hue_ ampoloj kaj _Ikea TRÅDFRI_ ampoloj), tiam la _CC2531_ povas administri la aparatojn malantaŭ ĉi tiu enkursigilo, kaj tiujn malantaŭ la enkursigiloj konektitaj al ĉi tiu enkursigilo ...  
Fakte la limo por la _CC2531_ estas multe pli alta. Kaj se iutage vi superas pli ol 50 aparatojn en via _zigbee_ reto, investi en pli multekosta kunordiganto estos nur malgranda parto de via buĝeto.  
Ankaŭ notu, ke la protokolo _zigbee_ limigas la nombron de rektaj ligoj al 32-a. Sendepende de via kunordiganto _zigbee_, ĝi ne povos konektiĝi al pli ol 32 ekstercentraj. 

## Mia ŝlosilo havas ĝian ruĝan LED, kiu lumigas.
Okazas, ke la ŝlosilo deprogramos, ĉu pro medio ŝarĝita de parazitoj aŭ pro malbona nutrobloko. 

1. Kontrolu vian nutroblokon

    
   ```bash
   grep Under /var/log/kern.log
   ```
Se vi ricevas multajn liniojn, tiam vi devas ŝanĝi nutroblokon. 

2. Malproksimigu la ŝlosilo de perturbaj materialoj: laŭtparoliloj, Wi-Fi enkursigiloj, ...


3. Reprogramu la ŝlosilon

 


## Permesilo

Ĉi tiu projekto estas rajtigita laŭ GPL v3 ( vidu _COPYING_ ).
