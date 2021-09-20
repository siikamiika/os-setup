#!/bin/sh

echo "Configuring nvim"

# install nvim-config
mkdir -p ~/koodi
[ ! -d "$(echo ~/koodi/nvim-config)" ] && git clone git@github.com:siikamiika/nvim-config.git ~/koodi/nvim-config
mkdir -p ~/.config/nvim
ln -sf ~/koodi/nvim-config/init.vim ~/.config/nvim/
mkdir -p ~/.cache/nvim/backup
mkdir -p ~/.cache/nvim/swap

# install Vundle.vim
mkdir -p ~/.vim/bundle
[ ! -d "$(echo ~/.vim/bundle/Vundle.vim)" ] && git clone https://github.com/VundleVim/Vundle.vim ~/.vim/bundle/Vundle.vim
