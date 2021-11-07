---
komentoj_id: 1
lang: ja
lang-niv: auto
lang-ref: 001-ĉefa-afero
layout: page
slug: 重要なこと！
title: 重要なこと
---

# [ _flash\_cc2531_ ](https://github.com/jmichault/flash_cc2531)
 [ _flash\_cc2531_ ](https://github.com/jmichault/flash_cc2531) ](https://github.com/jmichault/flash_cc2531)  _Raspberry_のCC2531 USBスティックを _Arduino_ または _CC Debugger_を必要とせずにプログラムすることができます。  

## 前提条件
 _Raspberry_ または _Odroid-c2_のいずれかが必要です。  
キーのデバッグポートを _Raspberry_のポート _GPIO_ に接続するものが必要です。たとえば、1本のケーブル _CC_ と4本の線 _Dupont_ (を参照してください(°10°）。   
[ _WiringPi_ ](http://wiringpi.com/) が事前にインストールされていない場合はインストールする必要があります \(、通常は `sudo apt install wiringpi`)でインストールできます。それ以外の場合は [ _Gordon_ ](http://wiringpi.com/) または [この代替サイト](https://github.com/WiringPi/WiringPi) \)のサイト。  
最後に、プログラムが必要です：

* 一般コーディネーター _zigbee_ ： [ バージョン1.2 (推奨)](https://github.com/Koenkk/Z-Stack-firmware/raw/master/coordinator/Z-Stack_Home_1.2/bin/default/) または [バージョン3.0](https://github.com/Koenkk/Z-Stack-firmware/tree/master/coordinator/Z-Stack_3.0.x/bin)°）


* またはルーター _zigbee_ ： [ルーター _zigbee_ 1.2](https://github.com/Koenkk/Z-Stack-firmware/tree/master/router/CC2531/bin)



 _flash\_cc2531_ を _raspbian_で _Raspberry Pi 3_ に投影しましたが、他のモデルでプログラミングの成功が報告されました：

 * pi 4では、バージョン2.52の _wiringpi_ が必要になります：  [インストール _wiringPi_ 2.52の _Gordon_ ](http://wiringpi.com/wiringpi-updated-to-2-52-for-the-raspberry-pi-4b/)Webサイト


 * pi1とpi2では、他のピン](#uzi_aliajn_pinglojn)を使用するために [が必要になります。



## 準備

 _flash\_cc2531_ を _raspberry_ にダウンロード：
```bash
git clone https://github.com/jmichault/flash_cc2531.git
```

紫色のポートの次のブリーブをGPIポートに接続します。
![](/public/raspberry-cc.png "disposition _raspberry_ et _CC_") 

| ..  

 _raspberry_ ピンレイアウトはこちらから入手できます： <https://pinout.xyz/>


その後、USBキーをポートに入力します。  

ダウンロードケーブル _CC_ と4本の線 _Dupont_ メスからメスはこの目的に最適です：
![キーの写真と _raspberry_ ](https://github.com/jmichault/files/raw/master/Raspberry-CC2531.jpg)）
これは私のお気に入りのオプションですが、ケーブル _CC_ がない場合は、キーにケーブル _Dupont_ を直接はんだ付けすることもできます。たとえば、Webサイト [ を参照してください。 °）_lemariva.com_ ](https://lemariva.com/blog/2019/08/zigbee-flashing-cc2531-using-raspberry-pi-without-cc-debugger) または [ _notenoughtech.com_ ](https://notenoughtech.com/home-automation/flashing-cc2531-without-cc-debugger )


これを試してください：
```bash
cd flash_cc2531
./cc_chipid
```
戻らなければなりません：
```
  ID = b524.
```
(キーのハードウェアバージョンが私のものと同じでない場合)、値が異なる場合があります。  
0000またはffffが表示された場合、何かが失敗します：

 * まず配線を確認してください。


 * 次に、たとえば `./cc_chipid -m 100`、 `./cc_chipid -m 160` 、または `./cc_chipid -m 300`を使用して、より高い基準時間を試してください。


 * これがうまくいかない場合は、 `make`で再コンパイルしてみてください。



## 使用法
フラッシュメモリの内容をsave.hexファイルに保存するには：
```bash
./cc_read save.hex
```
(は約2分)かかります。  

雷メモリを削除するには：（°1°1
```bash
./cc_erase
```
**注：** あなた **は、あなたが何をしようとしているのか)を本当に知らない限り、書く前に** 削除しなければなりません (。

キー _CC2531_のファイル _CC2531ZNP-Prod.hex_ をプログラムするには：
```bash
./cc_write CC2531ZNP-Prod.hex
```
(は約3分)続きます。

<a id="uzi_aliajn_pinglojn"></a>

## 他のピンを使用する

すべてのコマンドは次の引数を受け入れます：

 * _-c_ ピン：デフォルトでピン _DC_ (を変更します27)


 * _-d_ ピン：デフォルトでピン _DD_ (を変更します28)


 * _-r_ ピン：デフォルトでピン _reset_ (を変更します24)


 * _-m_ ：遅延乗数を変更し、したがってデフォルトでベース時間 (を変更します：自動調整)



使用されるピン番号は _wiringPi_の番号です。 `gpio readall` を使用して、 _Raspberry_ (列 _wPi_ )にレイアウトを配置します。

たとえば、ピン3、11、13を使用する場合：  
次のピンをデバッグポートからドアに接続します _GPIO_:

 1. ピン1 ( _GND_ ) -> ピン14 ( _GND_ )


 2. ピン7 ( _reset_ ) -> ピン3 ( _wPi 8, BCM2_ )


 3. ピン3 ( _DC_ ) -> ピン11 ( _wPi 0, BCM17_ )


 4. ピン4 ( _DD_ ) -> ピン13 ( _wPi 2, BCM27_ )



これで、次のコマンドを使用して、IDの読み取り、保存、削除、およびフラッシュメモリの書き込みを行うことができます。
```bash
./cc_chipid -r 8 -c 0 -d 2
./cc_read -r 8 -c 0 -d 2 save.hex
./cc_erase -r 8 -c 0 -d 2
./cc_write -r 8 -c 0 -d 2 CC2531ZNP-Prod.hex
```

デフォルト値を _CCDebugger.h_ に変更し、 `make`でプログラムをコンパイルすることもできます。

## それが機能しない場合はどうなりますか？

1. 他のすべてのプログラムを停止します。


2. プログラミングの前にプロセッサ速度を設定します。例：



   ```bash
   sudo echo performance >/sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
   ```
3. -mオプションを使用して、使用する制限時間を増やします。例：



   ```bash
   ./cc_write -m 300 CC2531ZNP-Prod.hex
   ```
4.  `make`でプログラムを再コンパイルします。



5. github](https://github.com/jmichault/flash_cc2531/issues?q=is%3Aissue)ですでに尋ねられた質問で解決策 [を探してください



6.  [github](https://github.com/jmichault/flash_cc2531/issues/new/choose)について独自の質問をしてください。



7. 栄養ブロックを確認してください（°1°1


    
   ```bash
   grep Under /var/log/kern.log
   ```
あなたがたくさんの行を手に入れるなら、あなたは栄養ブロックを変更する必要があります。  

## 私は15以上の周辺機器を接続したいです
鍵 _CC2531_ が15の最大機器のみを扱うことができるようなさまざまな場所で読みました。   
実際、 _CC2531_ の限界ははるかに高いです。  
また、プロトコル _zigbee_ は32thへの直接リンク数を制限することに注意してください。 

## 私の鍵は照らされた赤いLEDを持っています。
それは、寄生虫によってロードされた環境のため、または栄養不良のために、重要なデパログラムが発生することが起こります。  

1. 栄養ブロックを確認してください（°1°1


    
   ```bash
   grep Under /var/log/kern.log
   ```
あなたがたくさんの行を手に入れるなら、あなたは栄養ブロックを変更する必要があります。  

2. 邪魔されている材料への鍵から降りる：スピーカー、Wi-Fiルーター、...（°1°1



3. キーを再プログラム


 


## ライセンス

このプロジェクトは、GPL v3 ( でライセンスされています _COPYING_ )を参照してください。
