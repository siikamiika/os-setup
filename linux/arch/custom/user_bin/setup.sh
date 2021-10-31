#!/bin/sh

echo "Configuring user bin"

USER_BIN=~/.local/bin

mkdir -p "$USER_BIN"
find "$(pwd)/bin/" -maxdepth 1 -type f -exec ln -sf "{}" "$USER_BIN/" \;
