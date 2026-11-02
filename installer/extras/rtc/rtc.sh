#!/bin/bash
cd ~
sudo sh -c "echo 'dtoverlay=i2c-rtc,ds1307' >> /boot/config.txt"
sudo systemctl disable fake-hwclock
sudo apt-get -y remove fake-hwclock
sudo update-rc.d -f fake-hwclock remove
sudo cp m2ag-labs/installer/extras/rtc/lib/udev/hwclock-set /lib/udev
