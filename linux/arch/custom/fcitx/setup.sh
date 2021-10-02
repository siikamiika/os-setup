#!/bin/sh

echo "Configuring fcitx"

mkdir -p ~/.config/fcitx5/conf
cp profile ~/.config/fcitx5/profile
cp config ~/.config/fcitx5/config
find conf/ -maxdepth 1 -type f -exec cp "{}" ~/.config/fcitx5/conf/ \;

mkdir -p ~/.local/share/fcitx5/inputmethod
mkdir -p ~/.local/share/fcitx5/rime
cp keyboard-autism-common.conf ~/.local/share/fcitx5/inputmethod/
cp default.custom.yaml ~/.local/share/fcitx5/rime/

sudo cp qt_wayland_input_dialog /usr/local/bin
