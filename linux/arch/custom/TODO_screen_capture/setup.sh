#!/bin/sh

echo "Configuring screen capture"

mkdir -p ~/Pictures/screenshots
mkdir -p ~/Videos/screenrecords

sudo cp sway_select_area /usr/local/bin/
sudo cp screenshot-area /usr/local/bin/
sudo cp screenrecord-area /usr/local/bin/
