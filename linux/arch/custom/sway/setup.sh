#!/bin/sh

echo "Configuring sway"
mkdir -p ~/.config/sway
ln -sf "$(pwd)/config" ~/.config/sway/config
sudo cp ./get_focus_prompt /usr/local/bin/
sudo cp ./sway_gesture_input /usr/local/bin/
sudo cp ./sway_focus_pid /usr/local/bin/
