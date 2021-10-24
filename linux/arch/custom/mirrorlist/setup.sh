#!/bin/sh

echo "Configuring mirrorlist"

sudo pacman -S reflector
sudo pacman -S pacman-contrib

reflector --protocol https | tee mirrorlist.reflector
rankmirrors -v -n 10 ./mirrorlist.reflector | tee mirrorlist.rankmirrors
sudo cp ./mirrorlist.rankmirrors /etc/pacman.d/mirrorlist
rm ./mirrorlist.reflector ./mirrorlist.rankmirrors
