#!/bin/sh

echo "Configuring ranger"
ranger --copy-config=all

# TODO use diffs or maintain full version of the config

# rc.conf
RANGERRC=~/.config/ranger/rc.conf
# image preview
sed -i "/set preview_images false/c\set preview_images true" "$RANGERRC"
sed -i "/#set preview_script/s/^#//g" "$RANGERRC"
# mouse
sed -i "/set mouse_enabled true/c\set mouse_enabled false" "$RANGERRC"
# title
sed -i "/set update_title false/c\set update_title true" "$RANGERRC"
sed -i "/set update_tmux_title true/c\set update_tmux_title false" "$RANGERRC"
sed -i "/set tilde_in_titlebar false/c\set tilde_in_titlebar true" "$RANGERRC"
# delete
sed -i "/#map <DELETE>/s/^#//g" "$RANGERRC"
# pcmanfm
grep -qF "map <A-p> shell pcmanfm" "$RANGERRC" || sed -i "/map y. yank name_without_extension/a map <A-p> shell pcmanfm" "$RANGERRC"
# nvim session
grep -qF "map <A-o> shell nvim -S Session.vim" "$RANGERRC" || sed -i "/map y. yank name_without_extension/a map <A-o> shell nvim -S Session.vim" "$RANGERRC"
# fzf
grep -qF "map <C-g> console fzf_grep_select%space" "$RANGERRC" || sed -i "/map ca search_next order=atime/a map <C-g> console fzf_grep_select%space" "$RANGERRC"
grep -qF "map <A-f> console fzf_grep%space" "$RANGERRC" || sed -i "/map ca search_next order=atime/a map <A-f> console fzf_grep%space" "$RANGERRC"
grep -qF "map <C-f> fzf_select" "$RANGERRC" || sed -i "/map ca search_next order=atime/a map <C-f> fzf_select" "$RANGERRC"
# C-e
grep -qF "copymap K <C-E>" "$RANGERRC" || sed -i "/copymap K.*/a copymap K <C-E>" "$RANGERRC"
grep -qF "pmap  <C-e>       pager_move  up=0.5    pages=True" "$RANGERRC" || sed -i "/pmap.*<C-u>.*pager_move.*/a pmap  <C-e>       pager_move  up=0.5    pages=True" "$RANGERRC"
grep -qF "copypmap <C-e>      e" "$RANGERRC" || sed -i "/copypmap.*<C-u>.*u/a copypmap <C-e>      e" "$RANGERRC"
grep -qF "tmap <C-e>       taskview_move up=0.5    pages=True" "$RANGERRC" || sed -i "/tmap.*<C-u>.*taskview_move.*/a tmap <C-e>       taskview_move up=0.5    pages=True" "$RANGERRC"
grep -qF "copytmap <C-e>      e" "$RANGERRC" || sed -i "/copytmap.*<C-u>.*u/a copytmap <C-e>      e" "$RANGERRC"

# commands.py
cp "$(dirname "$0")/commands.py" ~/.config/ranger/
