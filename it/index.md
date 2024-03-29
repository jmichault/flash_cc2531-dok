---
komentoj_id: 1
lang: it
lang-niv: auto
lang-ref: 001-ĉefa-afero
layout: page
slug: 'La stessa cosa!'
title: 'La stessa cosa'
---

# [ _flash\_cc2531_ ](https://github.com/jmichault/flash_cc2531)
 [ _flash\_cc2531_ ](https://github.com/jmichault/flash_cc2531) Consente di programmare la tua chiavetta USB CC2531 dei _Raspberry_, senza la necessità di _Arduino_ o A _CC Debugger_.  

## Prerequisito
Hai bisogno di _Raspberry_ o _Odroid-c2_.  
È necessario cosa collegare la porta di debug della chiave alle porte _GPIO_ di _Raspberry_, ad esempio un cavo _CC_ e quattro linee _Dupont_ (vedi oltre).   
[ _WiringPi_ ](http://wiringpi.com/) deve essere installato \(se non è preinstallato, normalmente si può installare con `sudo apt install wiringpi`), altrimenti vedere [il sito di _Gordon_ ](http://wiringpi.com/) o [questo sito alternativo](https://github.com/WiringPi/WiringPi) \).  
Infine serve il programma:

* Coordinatore generale _zigbee_ : [ Versione 1.2 (Consigliato)](https://github.com/Koenkk/Z-Stack-firmware/raw/master/coordinator/Z-Stack_Home_1.2/bin/default/) o [Versione 3.0](https://github.com/Koenkk/Z-Stack-firmware/tree/master/coordinator/Z-Stack_3.0.x/bin)


* O Router _zigbee_ : [Router _zigbee_ 1.2](https://github.com/Koenkk/Z-Stack-firmware/tree/master/router/CC2531/bin)



Ho proiettato _flash\_cc2531_ su _Raspberry Pi 3_ con _raspbian_, ma la corretta programmazione è stata riportata su altri modelli:

 * su pi 4 sarà necessaria la versione 2.52 di _wiringpi_ :  [installa _wiringPi_ 2.52 del _Gordon_ ](http://wiringpi.com/wiringpi-updated-to-2-52-for-the-raspberry-pi-4b/)sito web


 * su pi 1 e pi 2 avrai bisogno di [per usare altri pin](#uzi_aliajn_pinglojn).



## Preparato

Scarica _flash\_cc2531_ nel tuo _raspberry_ :
```bash
git clone https://github.com/jmichault/flash_cc2531.git
```

Collegare i seguenti pin della porta viola alla porta GPO:
![](/public/raspberry-cc.png "disposition _raspberry_ et _CC_") 

|  

La disposizione dei pin _raspberry_ è disponibile qui: <https://pinout.xyz/>


Quindi inserire la chiave USB in porta.  

Il cavo di download _CC_ e 4 linee _Dupont_ femminili a femmina sono perfetti per questo scopo:
Foto della chiave e _raspberry_ ](https://github.com/jmichault/files/raw/master/Raspberry-CC2531.jpg)
Questa è la mia opzione preferita, ma se non si dispone di un cavo _CC_ è anche possibile rilasciare direttamente i cavi _Dupont_ sulla chiave: vedere ad esempio il sito [ _lemariva.com_ ](https://lemariva.com/blog/2019/08/zigbee-flashing-cc2531-using-raspberry-pi-without-cc-debugger) o [ _notenoughtech.com_ ](https://notenoughtech.com/home-automation/flashing-cc2531-without-cc-debugger )


prova questo:
```bash
cd flash_cc2531
./cc_chipid
```
Deve tornare:
```
  ID = b524.
```
(il valore può essere diverso se la versione hardware della tua chiave non è uguale alla mia).  
Se vedi 0000 o ffff qualcosa non è corretto: 

 * prima controlla il tuo cablaggio.


 * quindi provare un tempo base più alto, ad esempio con `./cc_chipid -m 100`, o `./cc_chipid -m 160` o `./cc_chipid -m 300`.


 * se niente di tutto questo funziona, prova a ricompilare con `make`.



## utilizzo
Per salvare il contenuto della memoria flash nel file save.hex:
```bash
./cc_read save.hex
```
(richiede circa 2 minuti).  

Per eliminare la memoria Lightning: 
```bash
./cc_erase
```
**Nota:** Devi **cancellare** prima di scrivere (a meno che tu non sappia veramente cosa intendi fare).

Per programmare il file _CC2531ZNP-Prod.hex_ sulla chiave _CC2531_:
```bash
./cc_write CC2531ZNP-Prod.hex
```
(dura circa 3 minuti).

<a id="uzi_aliajn_pinglojn"></a>

## Usa altri pin

tutti i comandi accettano i seguenti argomenti:

 * _-c_ pin: cambia il pin _DC_ (di default 27)


 * _-d_ pin: cambia il pin _DD_ (di default 28)


 * _-r_ pin: cambia il pin _reset_ (di default 24)


 * _-m_ : modifica il moltiplicatore del ritardo, e quindi il tempo base (di default: regolazione automatica)



la numerazione dei pin utilizzata è quella di _wiringPi_. Usa `gpio readall` per avere il layout nella tua colonna _Raspberry_ ( _wPi_ ).

Ad esempio, se si desidera utilizzare i pin 3, 11 e 13:  
Collegare i seguenti perni di Purifying Port to Port  _GPIO_: 

 1. perno 1 ( _GND_ ) -> perno 14 ( _GND_ )


 2. perno 7 ( _reset_ ) -> perno 3 ( _wPi 8, BCM2_ )


 3. perno 3 ( _DC_ ) -> perno 11 ( _wPi 0, BCM17_ )


 4. perno 4 ( _DD_ ) -> perno 13 ( _wPi 2, BCM27_ )



E ora puoi leggere un identificatore, salvare, eliminare e scrivere una memoria fulmine con i seguenti comandi:
```bash
./cc_chipid -r 8 -c 0 -d 2
./cc_read -r 8 -c 0 -d 2 save.hex
./cc_erase -r 8 -c 0 -d 2
./cc_write -r 8 -c 0 -d 2 CC2531ZNP-Prod.hex
```

## cosa succede se non funziona?

1. interrompere tutti gli altri programmi.


2. impostare la velocità del processore prima della programmazione. Esempio:



   ```bash
   sudo echo performance >/sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
   ```
3. utilizzare l'opzione -m per aumentare i limiti di tempo utilizzati. Esempio:



   ```bash
   ./cc_write -m 300 CC2531ZNP-Prod.hex
   ```
4. ricompilare il programma con `make`.



5. cerca una soluzione [nelle domande già poste su github](https://github.com/jmichault/flash_cc2531/issues?q=is%3Aissue)



6. Poni la tua domanda su [github](https://github.com/jmichault/flash_cc2531/issues/new/choose).



7. Controlla il tuo blocco nutrizione 


    
   ```bash
   grep Under /var/log/kern.log
   ```
Se ottieni un sacco di linee, devi cambiare il blocco nutrizionale.  

## Voglio connettere più di 15 periferia
Leggiamo in vari luoghi che la chiave _CC2531_ può gestire solo 15 dispositivi massimi.   
In effetti, il limite per _CC2531_ è molto più alto.   
Si noti inoltre che il protocollo  _zigbee_  limita il numero di collegamenti diretti al 32 °. Indipendentemente dal tuo coordinatore  _zigbee_, non sarà possibile connettersi a più di 32 periferiche. . 

## La mia chiave ha il suo LED rosso che si illumina.
Succede che i principali deprogrammi, sia dovuti all'ambiente caricato da parassiti o a causa della scarsa alimentazione.  

1. Controlla il tuo blocco nutrizione 


    
   ```bash
   grep Under /var/log/kern.log
   ```
Se ottieni un sacco di linee, devi cambiare il blocco nutrizionale.  

2. Ottieni la chiave dei materiali inquietanti: altoparlanti, router Wi-Fi, ...



3. Riprogrammare la chiave


 


## Licenza

Questo progetto è sotto licenza GPL v3 ( vedi _COPYING_ ).
