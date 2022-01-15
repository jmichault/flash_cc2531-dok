---
komentoj_id: 1
lang: ar
lang-niv: auto
lang-ref: 001-ĉefa-afero
layout: page
slug: 'الشيء الرئيسي!'
title: 'الشيء الرئيسي'
---

# [ _flash\_cc2531_ ](https://github.com/jmichault/flash_cc2531)
يمكنك  [  _flash\_cc2531_  ](https://github.com/jmichault/flash_cc2531)  من برمجة عصا USB CC2531 الخاصة بك  _Raspberry_، دون الحاجة إلى  _Arduino_  أو  _CC Debugger_.  
 يمكن أيضا برنامج مفتاح CC2530.  

## المتطلبات المسبقة
تحتاج إما _Raspberry_ أو _Odroid-c2_.  
تحتاج إلى ما توصل ميناء الأرجواني للمفتاح إلى المنافذ  _GPIO_  de  _Raspberry_، على سبيل المثال كابل واحد  _CC_  وأربعة خطوط  _Dupont_  ( شاهد المزيد ).    
 [  _WiringPi_  ](http://wiringpi.com/)  يجب تثبيته  \( إذا لم يكن مثبتا مسبقا، يمكنك عادة تثبيته مع  `sudo apt install wiringpi`)، وإلا ترى  [  _Gordon_  ](http://wiringpi.com/)  الموقع أو  [ هذا الموقع البديل ](https://github.com/WiringPi/WiringPi)  \).   
أخيرًا تحتاج البرنامج:

* عموما منسق  _zigbee_ :  [  الإصدار 1.2  ( الموصى بها )](https://github.com/Koenkk/Z-Stack-firmware/raw/master/coordinator/Z-Stack_Home_1.2/bin/default/)  أو  [ الإصدار 3.0 ](https://github.com/Koenkk/Z-Stack-firmware/tree/master/coordinator/Z-Stack_3.0.x/bin) 


* أو جهاز التوجيه _zigbee_ : [راوتر _zigbee_ 1.2](https://github.com/Koenkk/Z-Stack-firmware/tree/master/router/CC2531/bin)



لقد توقعت _flash\_cc2531_ على _Raspberry Pi 3_ مع _raspbian_، لكن تم الإبلاغ عن برمجة ناجحة في الطرز الأخرى:

 * في pi 4 ، ستحتاج إلى الإصدار 2.52 من _wiringpi_ :  [تثبيت _wiringPi_ 2.52 من _Gordon_ ](http://wiringpi.com/wiringpi-updated-to-2-52-for-the-raspberry-pi-4b/)موقع ويب


 * في pi 1 و pi 2 ستحتاج [لاستخدام دبابيس أخرى](#uzi_aliajn_pinglojn).



## أعدت

تنزيل _flash\_cc2531_ إلى _raspberry_ :
```bash
git clone https://github.com/jmichault/flash_cc2531.git
```

قم بتوصيل الدبابيس التالية بالمنفذ الأرجواني إلى منفذ GPO:
![](/public/raspberry-cc.png "disposition _raspberry_ et _CC_") 

|  

تخطيط الدبوس _raspberry_ متاح هنا: <https://pinout.xyz/>


ثم أدخل مفتاح USB في المنفذ.  

تنزيل كابل  _CC_  و 4 خطوط  _Dupont_  أنثى إلى أنثى مثالية لهذا الغرض: 
 ![ صورة للمفتاح وال  _raspberry_  
 
 هذا هو الخيار المفضل لدي، ولكن إذا كنت ليس لديك كابل  _CC_  يمكنك أيضا تشغيل الكابل  _Dupont_  على المفتاح: انظر على سبيل المثال  [  _lemariva.com_  ](https://lemariva.com/blog/2019/08/zigbee-flashing-cc2531-using-raspberry-pi-without-cc-debugger)  
  [   [   [   [   [   [   [   [   [   [   [   [   [   [   [   [   [   [   [   [   [   [  ](https://notenoughtech.com/home-automation/flashing-cc2531-without-cc-debugger )         


جرب هذا:
```bash
cd flash_cc2531
./cc_chipid
```
يجب أن يعود:
```
  ID = b524.
```
(قد تكون القيمة مختلفة إذا لم يكن إصدار الجهاز لمفتاحك مطابقًا لي).  
إذا رأيت 0000 أو FFFF شيء غير صحيح: 

 * تحقق أولاً من الأسلاك الخاصة بك.


 * ثم جرب وقت أساسي أعلى ، على سبيل المثال مع `./cc_chipid -m 100`أو `./cc_chipid -m 160` أو `./cc_chipid -m 300`.


 * إذا لم ينجح أي من هذا ، فحاول إعادة التحويل البرمجي باستخدام `make`.



## الاستخدام
لحفظ محتويات ذاكرة الفلاش في ملف save.hex:
```bash
./cc_read save.hex
```
(يستغرق حوالي 2 دقيقة).  

لحذف ذاكرة البرق: 
```bash
./cc_erase
```
**ملاحظة:** يجب عليك **حذف** قبل الكتابة (ما لم تكن تعرف حقًا ما الذي ستفعله).

لبرمجة الملف _CC2531ZNP-Prod.hex_ على المفتاح _CC2531_:
```bash
./cc_write CC2531ZNP-Prod.hex
```
(تدوم حوالي 3 دقائق).

<a id="uzi_aliajn_pinglojn"></a>

## استخدم دبابيس أخرى

تقبل جميع الأوامر الوسيطات التالية:

 * _-c_ دبوس: تغيير الدبوس _DC_ (افتراضيًا 27)


 * _-d_ دبوس: قم بتغيير الدبوس _DD_ (افتراضيًا 28)


 * _-r_ دبوس: قم بتغيير الدبوس _reset_ (افتراضيًا 24)


 * _-m_ : قم بتغيير مضاعف التأخير ، وبالتالي الوقت الأساسي (افتراضيًا: الضبط التلقائي)



رقم التعريف الشخصي المستخدم هو _wiringPi_. استخدم `gpio readall` للحصول على التخطيط في عمودك _Raspberry_ ( _wPi_ ).

على سبيل المثال ، إذا كنت تريد استخدام المسامير 3 و 11 و 13:  
قم بتوصيل المسامير التالية بمنفذ تنقية إلى المنفذ  _GPIO_: 

 1. دبوس 1 ( _GND_ ) -> دبوس 14 ( _GND_ )


 2. دبوس 7 ( _reset_ ) -> دبوس 3 ( _wPi 8, BCM2_ )


 3. دبوس 3 ( _DC_ ) -> دبوس 11 ( _wPi 0, BCM17_ )


 4. دبوس 4 ( _DD_ ) -> دبوس 13 ( _wPi 2, BCM27_ )



والآن يمكنك قراءة معرف وحفظ وحذف وكتابة ذاكرة صاعقة مع الأوامر التالية:
```bash
./cc_chipid -r 8 -c 0 -d 2
./cc_read -r 8 -c 0 -d 2 save.hex
./cc_erase -r 8 -c 0 -d 2
./cc_write -r 8 -c 0 -d 2 CC2531ZNP-Prod.hex
```

## ماذا لو لم يعمل؟

1. وقف جميع البرامج الأخرى.


2. اضبط سرعة المعالج قبل البرمجة. مثال:



   ```bash
   sudo echo performance >/sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
   ```
3. استخدم الخيار -m لزيادة الحدود الزمنية المستخدمة. مثال:



   ```bash
   ./cc_write -m 300 CC2531ZNP-Prod.hex
   ```
4. أعد ترجمة البرنامج باستخدام `make`.



5. ابحث عن حل [في الأسئلة المطروحة بالفعل على github](https://github.com/jmichault/flash_cc2531/issues?q=is%3Aissue)



6. اطرح سؤالك الخاص حول [github](https://github.com/jmichault/flash_cc2531/issues/new/choose).



7. تحقق كتلة التغذية الخاصة بك 


    
   ```bash
   grep Under /var/log/kern.log
   ```
إذا حصلت على الكثير من الخطوط، فعليك تغيير كتلة التغذية.  

## أريد توصيل أكثر من 15 محيط
نقرأ في مواقع مختلفة أن المفتاح  _CC2531_  يمكنه فقط التعامل مع 15 الأجهزة القصوى.    
 في الواقع، فإن البرامج الثابتة القياسية لهذا المفتاح لها حد 15 روابط مباشرة. ولكن إذا كانت إحدى هذه الاتصالات  _zigbee_  جهاز التوجيه  ( ومعظم الأجهزة تعمل كموجه، فهذا، على سبيل المثال، حالة  _Philips Hue_  لمبة )، ثم  _CC2531_  يمكن إدارة الأجهزة الموجودة وراء هذا التوجيه، والذين خلف جهاز التوجيه المتصلون بهذا الموجه ...   
في الواقع، الحد الأقصى ل _CC2531_ أعلى بكثير.   
لاحظ أيضا أن البروتوكول  _zigbee_  يحد من عدد الروابط المباشرة إلى 32. بغض النظر عن المنسق الخاص بك  _zigbee_، لن يكون من الممكن الاتصال بأكثر من 32 ملحقا.  

## المفتاح الخاص بي له بقيادة حمراء التي تضيء.
يحدث ذلك أن الفتحات الرئيسية، إما بسبب البيئة المحملة من الطفيليات أو بسبب سوء التغذية.  

1. تحقق كتلة التغذية الخاصة بك 


    
   ```bash
   grep Under /var/log/kern.log
   ```
إذا حصلت على الكثير من الخطوط، فعليك تغيير كتلة التغذية.  

2. الابتعاد مفتاح المواد المزعجة: مكبرات الصوت، جهاز التوجيه Wi-Fi، ...



3. إعادة برمجة المفتاح


 


## رخصة

هذا المشروع مُرخص بموجب GPL v3 ( انظر _COPYING_ ).
