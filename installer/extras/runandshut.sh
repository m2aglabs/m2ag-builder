#!/bin/bash
echo 'dtoverlay=gpio-shutdown,gpio_pin=17,active_low=1,gpio_pull=up' >> /boot/config.txt
echo 'dtoverlay=gpio-poweroff,gpiopin=19,active_low=1' >> /boot/config.txt



