#!/bin/sh

echo "Configuring kernel modules"

sudo cp 99-uinput.conf /etc/modules-load.d/
