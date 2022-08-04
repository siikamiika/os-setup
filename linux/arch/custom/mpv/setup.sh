#!/bin/sh

echo "Configuring mpv"
CONFDIR=~/.config/mpv
mkdir -p "$CONFDIR/bin"
mkdir -p "$CONFDIR/scripts"
mkdir -p "$CONFDIR/manual_scripts"
mkdir -p "$CONFDIR/dir_conf_storage"
find "$(pwd)/conf/"               -maxdepth 1 -type f -exec ln -sf "{}" "$CONFDIR/" \;
find "$(pwd)/conf/bin/"           -maxdepth 1 -type f -exec ln -sf "{}" "$CONFDIR/bin/" \;
find "$(pwd)/conf/scripts/"       -maxdepth 1 -type f -exec ln -sf "{}" "$CONFDIR/scripts/" \;
find "$(pwd)/conf/manual_scripts" -maxdepth 1 -type f -exec ln -sf "{}" "$CONFDIR/manual_scripts/" \;
ln -sf "$(pwd)/conf/bin/mpv_clipboard_subtitles.py" ~/.local/bin/
