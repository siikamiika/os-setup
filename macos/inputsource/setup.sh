#!/bin/bash

echo "Configuring inputsource"

swiftc ./macism.swift
mv ./macism ~/.local/bin/
