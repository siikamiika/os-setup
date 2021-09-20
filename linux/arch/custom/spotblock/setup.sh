#!/bin/sh

echo "Configuring spotblock"
systemctl --user enable spotblock.service
systemctl --user start spotblock.service
