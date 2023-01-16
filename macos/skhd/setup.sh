#!/bin/bash

echo "Configuring skhd"

brew install koekeishiya/formulae/skhd
mkdir -p ~/.config/skhd
ln -sf "$(pwd)/skhdrc" ~/.config/skhd/skhdrc
brew services start skhd
