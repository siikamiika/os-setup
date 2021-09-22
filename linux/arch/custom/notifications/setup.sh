#!/bin/sh

echo "Configuring dunst"
CONFDIR=~/.config/dunst
FILENAME="$CONFDIR/dunstrc"
[ ! -e "$FILENAME" ] && cp /etc/dunst/dunstrc "$CONFDIR"
mkdir -p "$CONFDIR"
patch -r - "$FILENAME" < ./dunstrc.patch
