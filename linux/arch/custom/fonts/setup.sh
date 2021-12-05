#!/bin/sh

echo "Configuring fonts"
CONFDIR="$HOME/.config/fontconfig/conf.d"
mkdir -p "$CONFDIR"

find "$(pwd)/conf.d/" -maxdepth 1 -type f -exec ln -sf "{}" "$CONFDIR/" \;
