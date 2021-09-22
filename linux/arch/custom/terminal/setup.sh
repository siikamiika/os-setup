#!/bin/sh

echo "Configuring alacritty"
CONFDIR=~/.config/alacritty
FILENAME="$CONFDIR/alacritty.yml"
mkdir -p "$CONFDIR"
[ ! -e "$FILENAME" ] && cp /usr/share/doc/alacritty/example/alacritty.yml "$CONFDIR"
patch -r - "$FILENAME" < ./alacritty.yml.patch
