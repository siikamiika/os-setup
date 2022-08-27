set fish_greeting

function r
    ranger $argv
end

eval (/opt/homebrew/bin/brew shellenv)

fish_add_path -g ~/.local/bin/
fish_add_path -g /opt/homebrew/opt/grep/libexec/gnubin/

set -g -x EDITOR nvim
