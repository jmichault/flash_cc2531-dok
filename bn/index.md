---
komentoj_id: ঘ
lang: bn
lang-niv: auto
lang-ref: 001-ĉefa-afero
layout: page
slug: 'প্রধান বিষয়!'
title: 'প্রধান বিষয়'
---

# [ _flash\_cc2531_ ](https://github.com/jmichault/flash_cc2531)
 [ ](https://github.com/jmichault/flash_cc2531)  _Raspberry_আপনার _Raspberry_বা আপনার _CC Debugger_বা একটি _CC Debugger_এর প্রয়োজন ছাড়াই প্রোগ্রাম করতে সক্ষম করে।  

## পূর্বশর্ত
আপনার প্রয়োজন হয় _Raspberry_ বা _Odroid-c2_।  
 _Raspberry_পোর্টগুলির _GPIO_ কীটির ডিবাগ বন্দরটি সংযুক্ত করার জন্য আপনার প্রয়োজন, উদাহরণস্বরূপ একটি কেবল _CC_ এবং চারটি লাইন _Dupont_ (আরও দেখুন)।   
[ _WiringPi_ ](http://wiringpi.com/) ইনস্টল করা আবশ্যক \(এটি প্রাক ইনস্টল না করা থাকলে আপনি সাধারণত এটি `sudo apt install wiringpi`)দিয়ে ইনস্টল করতে পারেন, অন্যথায় দেখুন [ _Gordon_ ](http://wiringpi.com/) বা [এই বিকল্প সাইটটি](https://github.com/WiringPi/WiringPi) \)  
শেষ পর্যন্ত আপনার প্রয়োজন প্রোগ্রাম:

* সাধারণত সমন্বয়কারী  _zigbee_ :  [  সংস্করণ 1.2  ( প্রস্তাবিত )](https://github.com/Koenkk/Z-Stack-firmware/raw/master/coordinator/Z-Stack_Home_1.2/bin/default/)  বা  [ সংস্করণ 3.0 ](https://github.com/Koenkk/Z-Stack-firmware/tree/master/coordinator/Z-Stack_3.0.x/bin) 


* বা রাউটার _zigbee_ রাউটার _zigbee_ 1.2](https://github.com/Koenkk/Z-Stack-firmware/tree/master/router/CC2531/bin)



আমি _flash\_cc2531_  _Raspberry Pi 3_ এর সাথে _raspbian_প্রজেক্ট করেছিলাম, তবে সফল প্রোগ্রামিংটি অন্যান্য মডেলগুলিতে প্রকাশিত হয়েছিল:

 * পাই 4 এ আপনার _wiringpi_ সংস্করণ 2.52 লাগবে:  [ইনস্টল _wiringPi_ 2.52 _Gordon_ ](http://wiringpi.com/wiringpi-updated-to-2-52-for-the-raspberry-pi-4b/)ওয়েবসাইট


 * পাই 1 এবং পাই 2 তে আপনার অন্যান্য পিনগুলি ব্যবহার করার জন্য [প্রয়োজন হবে](#uzi_aliajn_pinglojn)।



## প্রস্তুত

আপনার _raspberry_ এ _flash\_cc2531_ ডাউনলোড করুন:
```bash
git clone https://github.com/jmichault/flash_cc2531.git
```

জিপিও পোর্টে বেগুনি পোর্টের নিচের পিনটি সংযুক্ত করুন:
![](/public/raspberry-cc.png "disposition _raspberry_ et _CC_") 

|.  

 _raspberry_ পিন লেআউটটি এখানে পাওয়া যায়: <https://pinout.xyz/>


তারপর পোর্টে ইউএসবি কী লিখুন।  

কেবল  _CC_  এবং 4 টি লাইন  _Dupont_  মহিলা মহিলা মহিলাটি এই উদ্দেশ্যে নিখুঁত: 
 ![ কী এবং  _raspberry_  
 
 এটি আমার প্রিয় বিকল্প, কিন্তু যদি আপনি একটি তারের  _CC_  আপনি সরাসরি  _Dupont_  এর উপর সরাসরি খেলতে পারেন: উদাহরণস্বরূপ  [  _lemariva.com_   [  _lemariva.com_  
  [   [   [   [   [   [  ](https://notenoughtech.com/home-automation/flashing-cc2531-without-cc-debugger )       


এটি চেষ্টা করুন:
```bash
cd flash_cc2531
./cc_chipid
```
এটি অবশ্যই ফিরে আসতে হবে:
```
  ID = b524.
```
(মানটি ভিন্ন হতে পারে যদি আপনার কীটির হার্ডওয়্যার সংস্করণ খনি)এর মতো না হয়।  
যদি আপনি 0000 বা FFFF কিছু দেখেন তবে ভুল: 

 * প্রথমে আপনার ওয়্যারিং পরীক্ষা করুন।


 * তারপরে একটি উচ্চতর বেস সময় চেষ্টা করুন, উদাহরণস্বরূপ `./cc_chipid -m 100`, বা `./cc_chipid -m 160` বা `./cc_chipid -m 300`দিয়ে।


 * যদি এর কোনওটিই কাজ না করে, `make`দিয়ে পুনরায় সংযোগের চেষ্টা করুন।



## ব্যবহার
Save.hex ফাইলটিতে ফ্ল্যাশ মেমরির বিষয়বস্তু সংরক্ষণ করতে:
```bash
./cc_read save.hex
```
(প্রায় 2 মিনিট)লাগে।  

বাজ মেমরি মুছে ফেলতে: 
```bash
./cc_erase
```
**দ্রষ্টব্য:** আপনার **অবশ্যই লিখতে হবে** মুছে ফেলতে হবে (যদি না আপনি সত্যিই জানেন যে আপনি কী করতে যাচ্ছেন)।

কী _CC2531_ফাইল _CC2531ZNP-Prod.hex_ প্রোগ্রামটি প্রোগ্রাম করতে হবে:
```bash
./cc_write CC2531ZNP-Prod.hex
```
(প্রায় 3 মিনিট)স্থায়ী হয়।

<a id="uzi_aliajn_pinglojn"></a>

## অন্যান্য পিন ব্যবহার করুন

সমস্ত কমান্ড নিম্নলিখিত যুক্তিগুলি গ্রহণ করে:

 * _-c_ পিন: ডিফল্ট 27)দ্বারা পিনটি _DC_ (পরিবর্তন করুন


 * _-d_ পিন: ডিফল্ট 28)দ্বারা পিনটি _DD_ (পরিবর্তন করুন


 * _-r_ পিন: ডিফল্ট 24)দ্বারা পিনটি _reset_ (পরিবর্তন করুন


 * _-m_ : বিলম্ব গুণক পরিবর্তন করুন, এবং তাই বেস সময় (ডিফল্ট অনুসারে: স্বয়ংক্রিয় সমন্বয়)



ব্যবহৃত পিন নম্বরটি হ'ল _wiringPi_। আপনার _Raspberry_ (কলামে _wPi_ )লেআউট থাকতে `gpio readall` ব্যবহার করুন।

উদাহরণস্বরূপ, আপনি যদি পিন 3, 11 এবং 13 ব্যবহার করতে চান:  
পোর্টে পোর্টের পোর্টের নিচের পিনটি  _GPIO_:  সংযোগ করুন

 1. পিন 1 ( _GND_ ) -> পিন 14 ( _GND_ )


 2. পিন 7 ( _reset_ ) -> পিন 3 ( _wPi 8, BCM2_ )


 3. পিন 3 ( _DC_ ) -> পিন 11 ( _wPi 0, BCM17_ )


 4. পিন 4 ( _DD_ ) -> পিন 13 ( _wPi 2, BCM27_ )



এবং এখন আপনি নিম্নলিখিত কমান্ডগুলির সাথে একটি আইডেন্টিফায়ার, সংরক্ষণ, মুছে ফেলুন এবং একটি বাজ মেমরি পড়তে পারেন:
```bash
./cc_chipid -r 8 -c 0 -d 2
./cc_read -r 8 -c 0 -d 2 save.hex
./cc_erase -r 8 -c 0 -d 2
./cc_write -r 8 -c 0 -d 2 CC2531ZNP-Prod.hex
```

## যদি এটি কাজ না করে?

1. অন্যান্য সমস্ত প্রোগ্রাম বন্ধ করুন।


2. প্রোগ্রামিংয়ের আগে প্রসেসরের গতি সেট করুন। উদাহরণ:



   ```bash
   sudo echo performance >/sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
   ```
3. ব্যবহৃত সময়সীমা বাড়ানোর জন্য -m বিকল্পটি ব্যবহার করুন। উদাহরণ:



   ```bash
   ./cc_write -m 300 CC2531ZNP-Prod.hex
   ```
4.  `make`দিয়ে প্রোগ্রামটি পুনরায় কম্পাইল করুন।



5. গিথুব](https://github.com/jmichault/flash_cc2531/issues?q=is%3Aissue)এর উপর ইতিমধ্যে জিজ্ঞাসা করা প্রশ্নগুলির একটি সমাধান [সন্ধান করুন



6.  [গিথুব](https://github.com/jmichault/flash_cc2531/issues/new/choose)সম্পর্কে আপনার নিজের প্রশ্ন জিজ্ঞাসা করুন।



7. আপনার পুষ্টি পরীক্ষা করুন 


    
   ```bash
   grep Under /var/log/kern.log
   ```
যদি আপনি অনেক লাইন পান তবে আপনাকে পুষ্টি ব্লক পরিবর্তন করতে হবে।  

## আমি 15 টির বেশি পরিধি সংযোগ করতে চাই
আমরা বিভিন্ন জায়গায় পড়ি যে কীটি _CC2531_ শুধুমাত্র 15 টি সর্বোচ্চ ডিভাইস পরিচালনা করতে পারে।   
আসলে, সীমা _CC2531_ অনেক বেশি।   
এছাড়াও উল্লেখ্য যে প্রোটোকল _zigbee_ 32 তম সরাসরি লিঙ্কগুলির সংখ্যা সীমাবদ্ধ করে।  

## আমার কী তার লাল LED যে আলোকিত হয়েছে।
এটি প্যারাসাইটের দ্বারা লোড হওয়া পরিবেশের কারণে বা দরিদ্র পুষ্টির কারণে কীটি হ্রাস পায়।  

1. আপনার পুষ্টি পরীক্ষা করুন 


    
   ```bash
   grep Under /var/log/kern.log
   ```
যদি আপনি অনেক লাইন পান তবে আপনাকে পুষ্টি ব্লক পরিবর্তন করতে হবে।  

2. বিরক্তিকর উপকরণের কী দূরে পান: স্পিকার, ওয়াই-ফাই রাউটার, ...



3. কী reprogram


 


## লাইসেন্স

এই প্রকল্পটি জিপিএল ভি 3 ( দেখুন _COPYING_ )এর অধীনে লাইসেন্সযুক্ত।
