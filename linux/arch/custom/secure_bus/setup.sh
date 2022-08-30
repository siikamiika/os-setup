#!/bin/bash

echo "Configuring Secure Bus"

secure_bus_dir=~/koodi/secure-bus

pip3 install cryptography
[ ! -d "$secure_bus_dir" ] && git clone git@github.com:siikamiika/secure-bus.git "$secure_bus_dir"
ln -sf ~/koodi/secure-bus/secure_bus ~/.local/bin/
