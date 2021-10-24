#!/bin/sh

# TODO distro independent

install_yay ()
{
    sudo pacman -S fakeroot
    local dir=/tmp/yaybuild
    mkdir -p "$dir"
    curl -o "$dir/PKGBUILD" 'https://aur.archlinux.org/cgit/aur.git/plain/PKGBUILD?h=yay'
    (cd "$dir" && makepkg -si)
    rm -rf "$dir"
}

setup_software ()
{
    echo "TODO setup_software"
}

pre_install()
{
    echo
}

post_install()
{
    install_yay
    yay --editmenu -S --needed - < linux/arch/pkglist.txt
    setup_software
}

read -p "preinstall or post-install? [pre/post] "
if [[ $REPLY =~ ^pre$ ]]; then
    pre_install
elif [[ $REPLY =~ ^post$ ]]; then
    post_install
else
    echo "Unrecognized option: $REPLY"
fi
