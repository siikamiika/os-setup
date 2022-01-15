#!/bin/sh

echo "Configuring waybar"
mkdir -p ~/.config/waybar
ln -sf "$(pwd)/config" ~/.config/waybar/
ln -sf "$(pwd)/style.css" ~/.config/waybar/
