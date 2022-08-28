#!/bin/sh

echo "Configuring AltTab"

# hold alt...
defaults write com.lwouis.alt-tab-macos holdShortcut -string "⌥"
# ...and press tab
defaults write com.lwouis.alt-tab-macos nextWindowShortcut -string "⇥"
# back with shift-tab
defaults write com.lwouis.alt-tab-macos previousWindowShortcut -string "⇧⇥"

# show windows from all apps
defaults write com.lwouis.alt-tab-macos appsToShow -int 0
# show windows from current space
defaults write com.lwouis.alt-tab-macos spacesToShow -int 1
# show windows from current screen
defaults write com.lwouis.alt-tab-macos screensToShow -int 1
# show minimized windows
defaults write com.lwouis.alt-tab-macos showMinimizedWindows -int 0
# show hidden windows
defaults write com.lwouis.alt-tab-macos showHiddenWindows -int 0

# Windows 10 theme
defaults write com.lwouis.alt-tab-macos theme -int 1
