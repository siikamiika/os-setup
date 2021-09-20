#!/bin/sh

echo "Configuring fish"
mkdir -p ~/.config/fish/functions
cp "$(dirname "$0")/config.fish" ~/.config/fish/
cp "$(dirname "$0")/fish_user_key_bindings.fish" ~/.config/fish/functions/
