#!/bin/sh

echo "Configuring sway"
ln -sf "$(pwd)/config" ~/.config/sway/config
sudo cp get_focus_prompt /usr/local/bin/get_focus_prompt
