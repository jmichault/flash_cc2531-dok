---
komentoj_id: 1
lang: ms
lang-niv: auto
lang-ref: 001-ĉefa-afero
layout: page
slug: 'Perkara utama!'
title: 'Perkara utama'
---

# [ _flash\_cc2531_ ](https://github.com/jmichault/flash_cc2531)
 [ _flash\_cc2531_ ](https://github.com/jmichault/flash_cc2531) Membolehkan anda untuk memprogramkan batang USB CC2531 anda _Raspberry_, tanpa memerlukan _Arduino_ atau A _CC Debugger_.  

## Prasyarat
Anda memerlukan _Raspberry_ atau _Odroid-c2_.  
Anda memerlukan apa yang menghubungkan port debug kunci ke port _GPIO_  _Raspberry_, misalnya satu kabel _CC_ dan empat baris _Dupont_ (lihat lebih jauh).   
[ _WiringPi_ ](http://wiringpi.com/) mesti dipasang \(jika tidak dipasang sebelumnya, anda biasanya boleh memasangnya dengan `sudo apt install wiringpi`), jika tidak, lihat [tapak _Gordon_ ](http://wiringpi.com/) atau [tapak alternatif ini](https://github.com/WiringPi/WiringPi) \).  
Akhirnya anda memerlukan program:

* umumnya koordinator zigbee: [ versi 1.2 (disyorkan)](https://github.com/Koenkk/Z-Stack-firmware/raw/master/coordinator/Z-Stack_Home_1.2/bin/default/) atau [versi 3.0](https://github.com/Koenkk/Z-Stack-firmware/tree/master/coordinator/Z-Stack_3.0.x/bin)


* atau penghala zigbee: [penghala zigbee 1.2](https://github.com/Koenkk/Z-Stack-firmware/tree/master/router/CC2531/bin)



Saya mengunjurkan _flash\_cc2531_ pada _Raspberry Pi 3_ dengan _raspbian_, tetapi pengaturcaraan yang berjaya dilaporkan pada model lain:

 * pada pi 4 anda memerlukan versi 2.52 dari _wiringpi_ :  [memasang _wiringPi_ 2.52 dari _Gordon_ ](http://wiringpi.com/wiringpi-updated-to-2-52-for-the-raspberry-pi-4b/)laman web


 * pada pi 1 dan pi 2 anda memerlukan [untuk menggunakan pin lain](#uzi_aliajn_pinglojn).



## Bersedia

Muat turun _flash\_cc2531_ ke _raspberry_ :
```bash
git clone https://github.com/jmichault/flash_cc2531.git
```

Sambungkan yang berikut Pantai Ungu ke Port GPI:
![](/public/raspberry-cc.png "disposition _raspberry_ et _CC_") 

|  

Susun atur pin _raspberry_ boleh didapati di sini: <https://pinout.xyz/>


Kemudian masukkan kekunci USB ke pelabuhan.  

Muat turun kabel _CC_ dan 4 baris _Dupont_ Perempuan ke Perempuan sangat sesuai untuk tujuan ini:
![foto kunci dan _raspberry_ ](https://github.com/jmichault/files/raw/master/Raspberry-CC2531.jpg))
Ini adalah pilihan kegemaran saya, tetapi jika anda tidak mempunyai kabel _CC_ , anda juga boleh menyolder kabel secara langsung _Dupont_ pada kunci: lihat misalnya laman web [ _lemariva.com_ ](https://lemariva.com/blog/2019/08/zigbee-flashing-cc2531-using-raspberry-pi-without-cc-debugger) atau [ _notenoughtech.com_ ](https://notenoughtech.com/home-automation/flashing-cc2531-without-cc-debugger )


cuba ini:
```bash
cd flash_cc2531
./cc_chipid
```
Ia mesti kembali:
```
  ID = b524.
```
(nilainya mungkin berbeza jika versi perkakasan kunci anda tidak sama dengan kunci milik saya).  
Sekiranya anda melihat 0000 atau ffff sesuatu gagal:

 * periksa dahulu pendawaian anda.


 * kemudian cuba masa asas yang lebih tinggi, misalnya dengan `./cc_chipid -m 100`, atau `./cc_chipid -m 160` atau `./cc_chipid -m 300`.


 * jika tidak ada yang berfungsi, cuba kumpulkan semula dengan `make`.



## penggunaan
Untuk menyimpan kandungan memori flash ke fail save.hex:
```bash
./cc_read save.hex
```
(mengambil masa kira-kira 2 minit).  

Untuk mengosongkan memori kilat:
```bash
./cc_erase
```
**Catatan:** Anda **mesti** hapus sebelum menulis (kecuali anda benar-benar tahu apa yang akan anda lakukan).

Untuk memprogram fail _CC2531ZNP-Prod.hex_ pada kekunci _CC2531_:
```bash
./cc_write CC2531ZNP-Prod.hex
```
(berlangsung sekitar 3 minit).

<a id="uzi_aliajn_pinglojn"></a>

## Gunakan pin lain

semua arahan menerima hujah berikut:

 * _-c_ pin: ubah pin _DC_ (secara lalai 27)


 * Pin_-d_ : ubah pin _DD_ (secara lalai 28)


 * Pin_-r_ : ubah pin _reset_ (secara lalai 24)


 * _-m_ : ubah pengganda kelewatan, dan oleh itu masa asas (secara lalai: pelarasan automatik)



penomboran pin yang digunakan ialah _wiringPi_. Gunakan `gpio readall` untuk mempunyai susun atur di ruangan _Raspberry_ ( _wPi_ ).

Contohnya, jika anda ingin menggunakan pin 3, 11 dan 13:  
Sambungkan pin berikut dari port debug ke pintu _GPIO_:

 1. pin 1 ( _GND_ ) -> pin 14 ( _GND_ )


 2. pin 7 ( _reset_ ) -> pin 3 ( _wPi 8, BCM2_ )


 3. pin 3 ( _DC_ ) -> pin 11 ( _wPi 0, BCM17_ )


 4. pin 4 ( _DD_ ) -> pin 13 ( _wPi 2, BCM27_ )



dan sekarang anda boleh membaca ID, menyimpan, menghapus dan menulis memori flash dengan arahan berikut:
```bash
./cc_chipid -r 8 -c 0 -d 2
./cc_read -r 8 -c 0 -d 2 save.hex
./cc_erase -r 8 -c 0 -d 2
./cc_write -r 8 -c 0 -d 2 CC2531ZNP-Prod.hex
```

Anda juga boleh menukar nilai lalai ke _CCDebugger.h_ dan menyusun program dengan `make`.

## bagaimana jika ia tidak berfungsi?

1. hentikan semua program lain.


2. tetapkan kelajuan pemproses sebelum pengaturcaraan. Contoh:



   ```bash
   sudo echo performance >/sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
   ```
3. gunakan pilihan -m untuk meningkatkan had masa yang digunakan. Contoh:



   ```bash
   ./cc_write -m 300 CC2531ZNP-Prod.hex
   ```
4. menyusun semula program dengan `make`.



5. cari jalan penyelesaian [dalam soalan yang sudah diajukan di github](https://github.com/jmichault/flash_cc2531/issues?q=is%3Aissue)



6. Kemukakan soalan anda sendiri mengenai [github](https://github.com/jmichault/flash_cc2531/issues/new/choose).



7. Semak bekalan kuasa anda (° 1 ° 1


    
   ```bash
   grep Under /var/log/kern.log
   ```
Sekiranya anda mendapat banyak baris maka anda perlu menukar kuasa.  

## Saya mahu menyambung lebih daripada 15 pinggir
Kami membaca tentang lokasi yang berbeza yang kunci _CC2531_ hanya boleh mengendalikan 15 peralatan maksimum.  

## Kekunci saya mempunyai panduan merah yang menerangi.
Ia berlaku bahawa kemerosotan utama, sama ada disebabkan oleh persekitaran yang dimuatkan oleh parasit atau disebabkan oleh diet yang tidak baik.  

1. Semak bekalan kuasa anda (° 1 ° 1


    
   ```bash
   grep Under /var/log/kern.log
   ```
Sekiranya anda mendapat banyak baris maka anda perlu menukar kuasa.  

2. Turunkan kunci untuk mengganggu bahan: Pembesar suara, router Wi-Fi, ... (° 1 ° 1



3. Reprogram kekunci


 


## Lesen

Projek ini dilesenkan di bawah GPL v3 ( lihat _COPYING_ ).
