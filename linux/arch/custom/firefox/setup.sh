#!/bin/sh

echo "Configuring Firefox"

FF_ROOT=~/.mozilla/firefox
PROFILES_INI="$FF_ROOT/profiles.ini"

if [ ! -e "$PROFILES_INI" ]; then
    echo "Firefox profiles not found, exiting" && exit 1
fi

PROFILE_DIR="$FF_ROOT/$(grep -oP 'Default=\K.*' "$PROFILES_INI" | head -1 | sed 's#/##g')"
if [ ! -d "$PROFILE_DIR" ]; then
    echo "Invalid profile directory specified in profiles.ini" && exit 1
fi

cp ./user.js "$PROFILE_DIR/user.js"
