#!/bin/bash

echo "Configuring inputsource"

swiftc ./macism.swift
mv ./macism ~/.local/bin/

sudo cp ./autism.keylayout "/Library/Keyboard Layouts/"
