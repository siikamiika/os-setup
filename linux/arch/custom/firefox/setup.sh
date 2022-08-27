#!/bin/sh

echo "Configuring Firefox"

install_user_js()
{
    if [ "$(uname)" = "Linux" ]; then
        local ff_root=~/.mozilla/firefox
    elif [ "$(uname)" = "Darwin" ]; then
        local ff_root=~/Library/Application\ Support/Firefox
    fi
    local profiles_ini="$ff_root/profiles.ini"

    if [ ! -e "$profiles_ini" ]; then
        echo "Firefox profiles not found, exiting" && exit 1
    fi

    local profile_dir="$ff_root/$(grep -oP 'Default=\K[^1].*' "$profiles_ini" | head -1)"
    if [ ! -d "$profile_dir" ]; then
        echo "Invalid profile directory specified in profiles.ini" && exit 1
    fi

    cp ./user.js "$profile_dir/user.js"
}

install_tab_control()
{
    # TODO macos ~/Library/Application Support/Mozilla/NativeMessagingHosts/
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
    # TODO macos
    local src=/usr/share/applications/firefox-developer-edition.desktop
    local dest_dir=~/.local/share/applications
    local dest_entry=firefox-developer-edition-new-window.desktop
    local dest="$dest_dir/$dest_entry"
    mkdir -p "$dest_dir"
    cp "$src" "$dest"
    sed \
        -E 's/^(Exec=\/usr\/lib\/firefox-developer-edition\/firefox)( --class="firefoxdeveloperedition")? %u$/\1\2 --new-window %u/' \
        -i "$dest"
    xdg-settings set default-web-browser "$dest_entry"
}

install_user_js
if [ "$(uname)" = "Linux" ]; then
    install_tab_control
    set_default_browser
fi
