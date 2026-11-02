
Rtc:

This script and support file add an i2c RTC to the Raspberry pi.

Use sudo timedatectl to set ntp active.
```
sudo timedatectl set-ntp true
```
NTP may already be active.

A relevant clock command -- for verifying the hardware clock.
```
sudo hwclock -v 
```




References:

[https://learn.adafruit.com/adding-a-real-time-clock-to-raspberry-pi](https://learn.adafruit.com/adding-a-real-time-clock-to-raspberry-pi)

[https://www.raspberrypi.org/forums/viewtopic.php?t=85683](https://www.raspberrypi.org/forums/viewtopic.php?t=85683)

[https://www.raspberrypi.org/forums/viewtopic.php?t=194468](https://www.raspberrypi.org/forums/viewtopic.php?t=194468)
