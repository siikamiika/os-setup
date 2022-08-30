#!/bin/bash

echo "Configuring Karabiner-Elements"

mkdir -p ~/.config/karabiner/
./generate_config.py > ~/.config/karabiner/karabiner.json
