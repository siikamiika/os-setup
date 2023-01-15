#!/bin/bash

echo "Configuring fish"

mkdir -p ~/.config/fish/functions

if [ "$(uname)" = "Linux" ]; then
    # TODO use same install script
    cp "$(dirname "$0")/fish_user_key_bindings.fish" ~/.config/fish/functions/
    export IS_LINUX=1
    ifdef_preprocessor < ./config.fish.template > ~/.config/fish/config.fish
elif [ "$(uname)" = "Darwin" ]; then
    export IS_MACOS=1
    ifdef_preprocessor < ./config.fish.template > ~/.config/fish/config.fish
    $(brew --prefix)/opt/fzf/install
fi
