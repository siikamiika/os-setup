#!/bin/sh

echo "Configuring fish"
mkdir -p ~/.config/fish/functions
cp "$(dirname "$0")/config.fish" ~/.config/fish/
$(brew --prefix)/opt/fzf/install
