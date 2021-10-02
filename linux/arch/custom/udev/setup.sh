#!/bin/sh

echo "Configuring udev"

sudo usermod -a -G input "$USER"
sudo cp 99-uinput.rules /etc/udev/rules.d/
sudo udevadm control --reload-rules && sudo udevadm trigger
