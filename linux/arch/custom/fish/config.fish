set fish_greeting

function r
    ranger $argv
end

# https://github.com/systemd/systemd/issues/7641
export (/usr/lib/systemd/user-environment-generators/30-systemd-environment-d-generator)
