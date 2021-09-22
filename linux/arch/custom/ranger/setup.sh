#!/bin/sh

echo "Configuring ranger"
ranger --copy-config=all

CONFDIR=~/.config/ranger

# rc.conf
patch -r - "$CONFDIR/rc.conf" < ./rc.conf.patch

# commands.py
cp "$(dirname "$0")/commands.py" "$CONFDIR/"
