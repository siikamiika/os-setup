#!/bin/sh

# TODO distro independent

install_yay ()
{
	sudo pacman -S fakeroot
	mkdir -p yaybuild
	cd yaybuild
	curl -o PKGBUILD 'https://aur.archlinux.org/cgit/aur.git/plain/PKGBUILD?h=yay'
	makepkg -si
	cd ..
	rm -rf yaybuild
}

setup_software ()
{
	echo TODO
}

install_yay
yay --editmenu -S --needed - < linux/arch/pkglist.txt
