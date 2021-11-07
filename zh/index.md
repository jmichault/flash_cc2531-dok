---
komentoj_id: 1
lang: zh
lang-niv: auto
lang-ref: 001-ĉefa-afero
layout: page
slug: 最主要的！
title: 最主要的
---

# [ _flash\_cc2531_ ](https://github.com/jmichault/flash_cc2531)
 [ _flash\_cc2531_ _flash\_cc2531_ ](https://github.com/jmichault/flash_cc2531) ，您可以将您的CC2531 USB棒 _Raspberry_编程，无需 _Arduino_ 或 _CC Debugger_。  

## 先决条件
您需要 _Raspberry_ 或 _Odroid-c2_。  
您需要将钥匙的调试端口连接到 _Raspberry_的端口 _GPIO_ 的工具，例如一根电缆 _CC_ 和四根线 _Dupont_ ()。如果未预先安装   
[ _WiringPi_ ](http://wiringpi.com/)  \(，通常可以将其安装为 `sudo apt install wiringpi`)，否则请参见 [的位置 _Gordon_ ](http://wiringpi.com/) 或 [这个替代位置](https://github.com/WiringPi/WiringPi) \)。  
最后，您需要程序：

* 一般协调器 _zigbee_ : [ 版本1.2 (推荐)](https://github.com/Koenkk/Z-Stack-firmware/raw/master/coordinator/Z-Stack_Home_1.2/bin/default/) 或 [版本3.0](https://github.com/Koenkk/Z-Stack-firmware/tree/master/coordinator/Z-Stack_3.0.x/bin)（°13 °


* 或路由器 _zigbee_ : [路由器 _zigbee_ 1.2](https://github.com/Koenkk/Z-Stack-firmware/tree/master/router/CC2531/bin)



我将 _Raspberry Pi 3_ 与 _raspbian_投影在 _flash\_cc2531_ 上，但在其他型号上报告了成功的编程：

 * 在pi 4上，您将需要2.52版 _wiringpi_ ：  [安装 _wiringPi_ 2.52版 _Gordon_ ](http://wiringpi.com/wiringpi-updated-to-2-52-for-the-raspberry-pi-4b/)网站


 * 在pi 1和pi 2上，您需要 [使用其他引脚](#uzi_aliajn_pinglojn)。



## 准备好的

将 _flash\_cc2531_ 下载到您的 _raspberry_ ：
```bash
git clone https://github.com/jmichault/flash_cc2531.git
```

将以下紫色端口的售前连接到GPI端口：
![](/public/raspberry-cc.png "disposition _raspberry_ et _CC_") 

|  

此处提供 _raspberry_ 引脚布局： <https://pinout.xyz/>


然后将USB键进入端口。  

下载电缆 _CC_ 和4条线 _Dupont_ 母对母非常适合此目的：
![按键照片和 _raspberry_ ](https://github.com/jmichault/files/raw/master/Raspberry-CC2531.jpg)）
这是我最喜欢的选项，但是如果没有电缆 _CC_ ，也可以直接在键上焊接电缆 _Dupont_ ：例如，参见网站 [ _lemariva.com_ ](https://lemariva.com/blog/2019/08/zigbee-flashing-cc2531-using-raspberry-pi-without-cc-debugger) 或 [ _notenoughtech.com_ ](https://notenoughtech.com/home-automation/flashing-cc2531-without-cc-debugger )


试试这个：
```bash
cd flash_cc2531
./cc_chipid
```
它必须返回：
```
  ID = b524.
```
如果钥匙的硬件版本与我的钥匙)不同，则(值可能会不同。  
如果看到0000或ffff，则表示发生故障：

 * 首先检查您的接线。


 * 然后尝试更高的基准时间，例如 `./cc_chipid -m 100`或 `./cc_chipid -m 160` 或 `./cc_chipid -m 300`。


 * 如果这些都不起作用，请尝试使用 `make`重新编译。



## 用法
要将闪存的内容保存到save.hex文件：
```bash
./cc_read save.hex
```
(大约需要2分钟)。  

删除闪电记忆：（°1°1
```bash
./cc_erase
```
**注：** 除非 (，否则 **必须** 删除，除非您真的知道要做什么)。

在键 _CC2531_上编程文件 _CC2531ZNP-Prod.hex_ ：
```bash
./cc_write CC2531ZNP-Prod.hex
```
(持续约3分钟)。

<a id="uzi_aliajn_pinglojn"></a>

## 使用其他别针

所有命令均接受以下参数：

 * _-c_ 插针：默认情况下更改插针 _DC_ (27)


 * _-d_ 插针：默认情况下更改插针 _DD_ (28)


 * _-r_ 插针：默认情况下更改插针 _reset_ (24)


 * _-m_ ：更改延迟倍数，因此默认更改基准时间 (：自动调整)



使用的针脚编号是 _wiringPi_。使用 `gpio readall` 将布局放在 _Raspberry_ (列 _wPi_ )中。

例如，如果要使用引脚3、11和13：  
将以下引脚从调试端口连接到门 _GPIO_：

 1. 针1 ( _GND_ ) -> 针14 ( _GND_ )


 2. 引脚7 ( _reset_ ) -> 引脚3 ( _wPi 8, BCM2_ )


 3. 引脚3 ( _DC_ ) -> 引脚11 ( _wPi 0, BCM17_ )


 4. 针脚4 ( _DD_ ) -> 针脚13 ( _wPi 2, BCM27_ )



现在您可以使用以下命令读取ID，保存，删除和写入闪存：
```bash
./cc_chipid -r 8 -c 0 -d 2
./cc_read -r 8 -c 0 -d 2 save.hex
./cc_erase -r 8 -c 0 -d 2
./cc_write -r 8 -c 0 -d 2 CC2531ZNP-Prod.hex
```

您还可以将默认值更改为 _CCDebugger.h_ ，并使用 `make`编译程序。

## 如果不起作用怎么办？

1. 停止所有其他程序。


2. 在编程之前设置处理器速度。示例：



   ```bash
   sudo echo performance >/sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
   ```
3. 使用-m选项可以增加使用的时间限制。示例：



   ```bash
   ./cc_write -m 300 CC2531ZNP-Prod.hex
   ```
4. 用 `make`重新编译程序。



5. 在github](https://github.com/jmichault/flash_cc2531/issues?q=is%3Aissue)已经提出的问题中寻找解决方案 [



6. 询问关于 [github](https://github.com/jmichault/flash_cc2531/issues/new/choose)的问题。



7. 检查营养块（°1°1


    
   ```bash
   grep Under /var/log/kern.log
   ```
如果你得到很多线，那么你必须改变营养块。  

## 我想连接超过15个外围
我们在各个地方阅读，键 _CC2531_ 只能处理15个最大设备。   
实际上， _CC2531_ 的极限要高得多。  
另请注意，协议 _zigbee_ 限制直接链接到第32个。 

## 我的钥匙是它的红色LED，亮起。
它恰好是由于寄生虫装载的环境或由于营养不良而导致的关键常量。  

1. 检查营养块（°1°1


    
   ```bash
   grep Under /var/log/kern.log
   ```
如果你得到很多线，那么你必须改变营养块。  

2. 关闭令人不安的材料的关键：扬声器，Wi-Fi路由器，...（°1°1



3. 重新编程键


 


## 执照

此项目已获得GPL v3许可 ( ，请参见 _COPYING_ )。
