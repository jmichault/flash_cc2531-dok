---
komentoj_id: 1
lang: pt
lang-niv: auto
lang-ref: 001-ĉefa-afero
layout: page
slug: 'A coisa principal!'
title: 'A coisa principal'
---

# [ _flash\_cc2531_ ](https://github.com/jmichault/flash_cc2531)
 [ _flash\_cc2531_ ](https://github.com/jmichault/flash_cc2531) Permite programar o seu CC2531 USB Stick do seu _Raspberry_, sem a necessidade de _Arduino_ ou A _CC Debugger_.  

## Pré-requisito
Você precisa de _Raspberry_ ou _Odroid-c2_.  
Você precisa do que conectar a porta de depuração da chave às portas _GPIO_ de _Raspberry_, por exemplo, um cabo _CC_ e quatro linhas _Dupont_ (veja mais).   
[ _WiringPi_ ](http://wiringpi.com/) deve ser instalado \(se não estiver pré-instalado, geralmente você pode instalá-lo com `sudo apt install wiringpi`), caso contrário, consulte [o local de _Gordon_ ](http://wiringpi.com/) ou [este local alternativo](https://github.com/WiringPi/WiringPi) \).  
Finalmente você precisa do programa:

* geralmente coordenador zigbee: [ versão 1.2 (recomendado)](https://github.com/Koenkk/Z-Stack-firmware/raw/master/coordinator/Z-Stack_Home_1.2/bin/default/) ou [versão 3.0](https://github.com/Koenkk/Z-Stack-firmware/tree/master/coordinator/Z-Stack_3.0.x/bin)


* ou roteador zigbee: [roteador zigbee 1,2](https://github.com/Koenkk/Z-Stack-firmware/tree/master/router/CC2531/bin)



Projetei _flash\_cc2531_ em _Raspberry Pi 3_ com _raspbian_, mas a programação bem-sucedida foi relatada em outros modelos:

 * no pi 4, você precisará da versão 2.52 de _wiringpi_ :  [instalar _wiringPi_ 2.52 de _Gordon_ ](http://wiringpi.com/wiringpi-updated-to-2-52-for-the-raspberry-pi-4b/)site


 * no pi 1 e no pi 2 você precisará [para usar outros pinos](#uzi_aliajn_pinglojn).



## Preparado

Baixe _flash\_cc2531_ para seu _raspberry_ :
```bash
git clone https://github.com/jmichault/flash_cc2531.git
```

Conecte os seguintes contravores da porta roxa à porta GPI:
![](/public/raspberry-cc.png "disposition _raspberry_ et _CC_") 

|  

O layout do pino _raspberry_ está disponível aqui: <https://pinout.xyz/>


Em seguida, insira a chave USB na porta.  

Cabo de download _CC_ e 4 linhas _Dupont_ Fêmea para Fêmea são perfeitos para esta finalidade:
![foto da chave e a _raspberry_ ](https://github.com/jmichault/files/raw/master/Raspberry-CC2531.jpg))
Esta é a minha opção preferida, mas se você não tem um cabo _CC_ você também pode soldar os cabos diretamente _Dupont_ na chave: veja por exemplo o site [ _lemariva.com_ ](https://lemariva.com/blog/2019/08/zigbee-flashing-cc2531-using-raspberry-pi-without-cc-debugger) ou [ _notenoughtech.com_ ](https://notenoughtech.com/home-automation/flashing-cc2531-without-cc-debugger )


tente isto:
```bash
cd flash_cc2531
./cc_chipid
```
Deve retornar:
```
  ID = b524.
```
(o valor pode ser diferente se a versão do hardware da sua chave não for igual à minha).  
Se você vir 0000 ou ffff, algo falha:

 * primeiro verifique sua fiação.


 * em seguida, tente um tempo base maior, por exemplo com `./cc_chipid -m 100`, ou `./cc_chipid -m 160` ou `./cc_chipid -m 300`.


 * se nada disso funcionar, tente recompilar com `make`.



## uso
Para salvar o conteúdo da memória flash no arquivo save.hex:
```bash
./cc_read save.hex
```
(leva cerca de 2 minutos).  

Para limpar uma memória flash:
```bash
./cc_erase
```
**Nota:** Você **deve** deletar antes de escrever (a menos que você realmente saiba o que vai fazer).

Para programar o arquivo _CC2531ZNP-Prod.hex_ na chave _CC2531_:
```bash
./cc_write CC2531ZNP-Prod.hex
```
(dura cerca de 3 minutos).

<a id="uzi_aliajn_pinglojn"></a>

## Use outros pinos

todos os comandos aceitam os seguintes argumentos:

 * _-c_ pino: alterar o pino _DC_ (por padrão 27)


 * _-d_ pino: alterar o pino _DD_ (por padrão 28)


 * _-r_ pino: alterar o pino _reset_ (por padrão 24)


 * _-m_ : altera o multiplicador de atraso e, portanto, o tempo base (por padrão: ajuste automático)



a numeração do pino usada é a de _wiringPi_. Use `gpio readall` para ter o layout em sua coluna _Raspberry_ ( _wPi_ ).

Por exemplo, se você quiser usar os pinos 3, 11 e 13:  
Conecte os seguintes pinos de uma porta de depuração a uma porta _GPIO_:

 1. pino 1 ( _GND_ ) -> pino 14 ( _GND_ )


 2. pino 7 ( _reset_ ) -> pino 3 ( _wPi 8, BCM2_ )


 3. pino 3 ( _DC_ ) -> pino 11 ( _wPi 0, BCM17_ )


 4. pino 4 ( _DD_ ) -> pino 13 ( _wPi 2, BCM27_ )



e agora você pode ler ID, salvar, excluir e gravar a memória flash com os seguintes comandos:
```bash
./cc_chipid -r 8 -c 0 -d 2
./cc_read -r 8 -c 0 -d 2 save.hex
./cc_erase -r 8 -c 0 -d 2
./cc_write -r 8 -c 0 -d 2 CC2531ZNP-Prod.hex
```

Você também pode alterar os valores padrão para _CCDebugger.h_ e compilar os programas com `make`.

## e se não funcionar?

1. pare todos os outros programas.


2. defina a velocidade do processador antes de programar. Exemplo:



   ```bash
   sudo echo performance >/sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
   ```
3. use a opção -m para aumentar os limites de tempo usados. Exemplo:



   ```bash
   ./cc_write -m 300 CC2531ZNP-Prod.hex
   ```
4. recompile o programa com `make`.



5. procure uma solução [nas questões já feitas no github](https://github.com/jmichault/flash_cc2531/issues?q=is%3Aissue)



6. Faça sua pergunta sobre [github](https://github.com/jmichault/flash_cc2531/issues/new/choose).



7. Verifique sua fonte de alimentação (° 1 ° 1


    
   ```bash
   grep Under /var/log/kern.log
   ```
Se você receber muitas linhas, então você tem que mudar de poder.  

## Eu quero conectar mais de 15 periferia
Nós lemos sobre diferentes locais que a chave _CC2531_ só pode lidar com 15 aparelhos máximos.  

## Minha chave tem seu guia vermelho que ilumina.
Acontece que a chave depletagem, devido ao meio ambiente carregado por parasitas ou devido a uma dieta ruim.  

1. Verifique sua fonte de alimentação (° 1 ° 1


    
   ```bash
   grep Under /var/log/kern.log
   ```
Se você receber muitas linhas, então você tem que mudar de poder.  

2. Saia da chave para materiais perturbadores: alto-falantes, roteadores Wi-Fi, ... (° 1 ° 1



3. Reprogramar a chave


 


## Licença

Este projeto está licenciado sob a GPL v3 ( ver _COPYING_ ).
