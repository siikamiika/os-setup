#!/bin/sh

echo "Configuring zram"
sudo modprobe zram
sudo cp zram-generator.conf /etc/systemd/
sudo cp 99-swap.conf /etc/sysctl.d/
sudo systemctl start systemd-zram-setup@zram0.service
