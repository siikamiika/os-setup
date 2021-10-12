#!/bin/sh

echo "Configuring ranger"
ranger --copy-config=all

CONFDIR=~/.config/ranger

# rc.conf
patch -r - "$CONFDIR/rc.conf" < ./rc.conf.patch

# rifle.conf
patch -r - "$CONFDIR/rifle.conf" < ./rifle.conf.patch

# commands.py
cp "$(dirname "$0")/commands.py" "$CONFDIR/"
