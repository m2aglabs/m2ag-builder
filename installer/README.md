# Installs the m2ag.labs webthings based iot framework

Some assembly required!

Use install.sh to install base framework

Ensure i2c is enabled on your pi.

Use of ssl is encouraged but not mandatory. Place self-signed certificates in $HOME and the installer will copy them to the correct place.

This [document](https://1drv.ms/w/s!Aji-cHyARexHkJk7-fODiKhT-N8Vmg?e=WYJ69b) discusses how to create self-signed certificates

beta 1 6/10/21

To assist with prerequisites try this [doc](https://1drv.ms/w/s!Aji-cHyARexHkJlDPnITOS8HCj6DSA?e=z2di5M)

<!--
 Here is a [video](https://www.youtube.com/watch?v=eedckN2m7Ew) walk through of an install. 

 Here is a [video](https://youtu.be/h66wyPyMx8Y) using thing builder with webthings.io
 -->

install with:

Raspberry PI:
```
bash -c "$(curl -fsSL https://raw.githubusercontent.com/m2ag-labs/m2ag-webthings-builder/main/installer/install.sh)"
```


