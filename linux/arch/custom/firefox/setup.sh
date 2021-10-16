#!/bin/sh

echo "Configuring Firefox"

install_user_js()
{
    local ff_root=~/.mozilla/firefox
    local profiles_ini="$ff_root/profiles.ini"

    if [ ! -e "$profiles_ini" ]; then
        echo "Firefox profiles not found, exiting" && exit 1
    fi

    local profile_dir="$ff_root/$(grep -oP 'Default=\K.*' "$profiles_ini" | head -1 | sed 's#/##g')"
    if [ ! -d "$profile_dir" ]; then
        echo "Invalid profile directory specified in profiles.ini" && exit 1
    fi

    cp ./user.js "$profile_dir/user.js"
}

install_tab_control()
{
    local vc_dir=~/koodi/firefox-tab-control
    local nmh_dir=~/.mozilla/native-messaging-hosts
    [ ! -d "$vc_dir" ] && git clone git@github.com:siikamiika/firefox-tab-control.git "$vc_dir"
    mkdir -p "$nmh_dir"
    (
        cd "$vc_dir/" &&
        ./build.sh &&
        cp tab_control.json "$nmh_dir/" &&
        sudo cp tab_control@miika.es.xpi /usr/lib/firefox-developer-edition/browser/extensions/ &&
        sudo cp tab_control.py "$(jq -r '.path' tab_control.json)"
    )
}

set_default_browser()
{
    local src=/usr/share/applications/firefox-developer-edition.desktop
    local dest_dir=~/.local/share/applications
    local dest_entry=firefox-developer-edition-new-window.desktop
    local dest="$dest_dir/$dest_entry"
    mkdir -p "$dest_dir"
    cp "$src" "$dest"
    sed \
        -e '/^Exec=\/usr\/lib\/firefox-developer-edition\/firefox %u$/c Exec=\/usr\/lib\/firefox-developer-edition\/firefox --new-window %u' \
        -i "$dest"
    xdg-settings set default-web-browser "$dest_entry"
}

install_user_js
install_tab_control
set_default_browser
