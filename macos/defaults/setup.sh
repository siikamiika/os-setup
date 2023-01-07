#!/bin/sh

echo "Configuring macOS defaults"

# set key repeat rate and delay
defaults write -g InitialKeyRepeat -int 20 # 300 ms
defaults write -g KeyRepeat -int 1 # 15 ms (2 would be 30 ms)

# enable key repeat on letter keys
defaults write -g ApplePressAndHoldEnabled -bool false

# disable autocorrect
defaults write -g NSAutomaticSpellingCorrectionEnabled -bool false

# good riddance
defaults write com.apple.finder QuitMenuItem -bool YES
