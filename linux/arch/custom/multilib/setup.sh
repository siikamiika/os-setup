#!/bin/sh

echo "Configuring multilib"
sudo patch -r - /etc/pacman.conf < ./pacman.conf.patch
