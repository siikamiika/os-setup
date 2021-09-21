#!/bin/sh

echo "Configuring zram"
sudo modprobe zram
sudo cp zram-generator.conf /etc/systemd/
sudo systemctl start systemd-zram-setup@zram0.service
