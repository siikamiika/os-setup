#!/bin/sh

echo "Configuring BlueZ"
sudo sed -i "/#AutoEnable=false/c\AutoEnable=true" /etc/bluetooth/main.conf
sudo systemctl enable bluetooth
sudo systemctl start bluetooth
