#!/bin/bash

echo "Configuring tmux"

tmux_dir=~/.config/tmux/

mkdir -p "$tmux_dir"
ln -sf "$(pwd)/tmux.conf" "$tmux_dir"
