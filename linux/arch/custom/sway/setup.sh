#!/bin/sh

echo "Configuring sway"
ln -sf "$(pwd)/config" ~/.config/sway/config
sudo cp get_focus_prompt /usr/local/bin/
sudo cp sway_gesture_input /usr/local/bin/
sudo cp fzf-launcher /usr/local/bin/
