#!/bin/bash

echo "Configuring kitty"

mkdir -p ~/.config/kitty
ln -sf "$(pwd)/kitty.conf" ~/.config/kitty/
