#!/usr/bin/env bash

os="$(uname -s)"
case "$os" in
    Linux)
        ranger_config="/usr/share/doc/ranger/config"
        ;;
    Darwin)
        ranger_config="/opt/homebrew/opt/ranger/libexec/ranger/config"
        ;;
    *)
        echo "Unknown os: $os"
        exit 1
        ;;
esac

update_or_create_patch.sh "$ranger_config/rc.conf" ~/.config/ranger/rc.conf .
update_or_create_patch.sh "$ranger_config/rifle.conf" ~/.config/ranger/rifle.conf .
