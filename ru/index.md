---
lang: ru
lang-niv: auto
lang-ref: 001-ĉefa-afero
layout: page
slug: Главное!
title: Главное
---

# [ _flash\_cc2531_ ](https://github.com/jmichault/flash_cc2531)
 [ _flash\_cc2531_ ](https://github.com/jmichault/flash_cc2531) позволяет программировать USB-ключ CC2531 с вашего _Raspberry_, без необходимости _Arduino_ или _CC Debugger_.

## Предпосылка
Вам нужно либо _Raspberry_ , либо _Odroid-c2_.  
Вам нужно, что подключить порт отладки ключа к портам _GPIO_ из _Raspberry_, например один кабель _CC_ и четыре линии _Dupont_ (см. Далее).   
[ _WiringPi_ ](http://wiringpi.com/) должен быть установлен \(, если он не установлен предварительно, вы обычно можете установить его с помощью `sudo apt install wiringpi`), в противном случае см. [место _Gordon_ ](http://wiringpi.com/) или [это альтернативное место](https://github.com/WiringPi/WiringPi) \).  
Наконец, вам нужна программа:

* обычно координатор зигби: [ версия 1.2 (рекомендуется)](https://github.com/Koenkk/Z-Stack-firmware/raw/master/coordinator/Z-Stack_Home_1.2/bin/default/) или [версия 3.0](https://github.com/Koenkk/Z-Stack-firmware/tree/master/coordinator/Z-Stack_3.0.x/bin)


* или zigbee router: [zigbee router 1.2](https://github.com/Koenkk/Z-Stack-firmware/tree/master/router/CC2531/bin)



Я проецировал _flash\_cc2531_ на _Raspberry Pi 3_ с помощью _raspbian_, но сообщалось об успешном программировании на других моделях:

 * на Pi 4 вам понадобится версия 2.52 из _wiringpi_ :  [установить _wiringPi_ 2,52 из _Gordon_ ](http://wiringpi.com/wiringpi-updated-to-2-52-for-the-raspberry-pi-4b/)веб-сайт


 * на pi 1 и pi 2 вам понадобится [, чтобы использовать другие штифты](#uzi_aliajn_pinglojn).


 * однако вам, вероятно, потребуется установить опцию развертки времени ( _"-m"_ ).



## Подготовлено

Загрузите _flash\_cc2531_ в ваш _raspberry_ :
```bash
git clone https://github.com/jmichault/flash_cc2531.git
```

Подключите следующие контакты от порта отладки к порту GPIO:

 1. штифт 1 ( _GND_ ) -> штифт 39 ( _GND_ )


 2. штифт 7 ( _reset_ ) -> штифт 35 ( _wPi 24, BCM19_ )


 3. штифт 3 ( _DC_ ) -> штифт 36 ( _wPi 27, BCM16_ )


 4. штифт 4 ( _DD_ ) -> штифт 38 ( _wPi 28, BCM20_ )



Расположение выводов _raspberry_ доступно здесь: <https://pinout.xyz/>

и вставьте USB-ключ в порт.

Кабель для скачивания _CC_ и 4 линии _Dupont_ между гнездом и гнездом идеально подходят для этой цели:
![фотография ключа и _raspberry_ ](https://github.com/jmichault/files/raw/master/Raspberry-CC2531.jpg))
Это мой любимый вариант, но если у вас нет кабеля _CC_ , вы также можете напрямую припаять кабели _Dupont_ к ключу: см., Например, веб-сайт [ _lemariva.com_ ](https://lemariva.com/blog/2019/08/zigbee-flashing-cc2531-using-raspberry-pi-without-cc-debugger) или [ _notenoughtech.com_ ](https://notenoughtech.com/home-automation/flashing-cc2531-without-cc-debugger )


попробуйте это:
```bash
cd flash_cc2531
./cc_chipid
```
Он должен вернуться:
```
  ID = b524.
```
(значение может быть другим, если аппаратная версия вашего ключа не такая же, как у меня).  
Если вы видите 0000 или ffff, что-то не работает:

 * сначала проверьте свою проводку.


 * затем попробуйте более высокое базовое время, например, с `./cc_chipid -m 100`, или `./cc_chipid -m 160` , или `./cc_chipid -m 300`.


 * если ничего из этого не работает, попробуйте перекомпилировать с `make`.



## Применение
Чтобы сохранить содержимое флэш-памяти в файл save.hex:
```bash
./cc_read save.hex
```
(длится около 1 минуты).

Чтобы очистить флэш-память:
```bash
./cc_erase
```
**Примечание:** Вы **должны** удалить перед записью (, если вы действительно не знаете, что собираетесь делать).

Чтобы запрограммировать файл _CC2531ZNP-Prod.hex_ на клавишу _CC2531_:
```bash
./cc_write CC2531ZNP-Prod.hex
```
(длится около 3 минут).

<a id="uzi_aliajn_pinglojn"></a>

## Используйте другие булавки

все команды принимают следующие аргументы:

 * _-c_ штифт: измените штифт _DC_ (по умолчанию 27)


 * _-d_ штифт: измените штифт _DD_ (по умолчанию 28)


 * _-r_ штифт: измените штифт _reset_ (по умолчанию 24)


 * _-m_ : изменить множитель задержки и, следовательно, базовое время (по умолчанию: автоматическая регулировка)



используется нумерация штифтов _wiringPi_. Используйте `gpio readall` , чтобы разместить макет в столбце _Raspberry_ ( _wPi_ ).

Например, если вы хотите использовать контакты 3, 11 и 13:  
Подключите следующие контакты от порта отладки к двери _GPIO_:

 1. штифт 1 ( _GND_ ) -> штифт 14 ( _GND_ )


 2. штифт 7 ( _reset_ ) -> штифт 3 ( _wPi 8, BCM2_ )


 3. штифт 3 ( _DC_ ) -> штифт 11 ( _wPi 0, BCM17_ )


 4. штифт 4 ( _DD_ ) -> штифт 13 ( _wPi 2, BCM27_ )



и теперь вы можете читать ID, сохранять, удалять и записывать флеш-память с помощью следующих команд:
```bash
./cc_chipid -r 8 -c 0 -d 2
./cc_read -r 8 -c 0 -d 2 save.hex
./cc_erase -r 8 -c 0 -d 2
./cc_write -r 8 -c 0 -d 2 CC2531ZNP-Prod.hex
```

Вы также можете изменить значения по умолчанию на _CCDebugger.h_ и скомпилировать программы с `make`.

## что если это не сработает?

1. остановите все другие программы.


2. перед программированием установите скорость процессора. Пример:



   ```bash
   sudo echo performance >/sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
   ```
3. используйте опцию -m, чтобы увеличить используемые временные ограничения. Пример:



   ```bash
   ./cc_write -m 300 CC2531ZNP-Prod.hex
   ```
4. перекомпилируйте программу с `make`.



5. ищите решение [в уже заданных вопросах на github](https://github.com/jmichault/flash_cc2531/issues?q=is%3Aissue)



6. Задайте свой вопрос о [github](https://github.com/jmichault/flash_cc2531/issues/new/choose).



## Лицензия

Этот проект находится под лицензией GPL v3 ( см. _COPYING_ ).
