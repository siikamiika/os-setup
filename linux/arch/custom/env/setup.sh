#!/bin/sh

echo "Configuring environment"

sudo cp ./upsert_env /usr/local/bin/
sudo cp ./upsert_user_env /usr/local/bin/

# default software
upsert_env EDITOR /usr/bin/nvim
upsert_env DMENU /usr/local/bin/fzf-launcher

# path
upsert_user_env PATH '"$PATH:${HOME}/.local/bin"'

# firefox
upsert_env MOZ_ENABLE_WAYLAND 1

# fcitx
upsert_env XIM fcitx
upsert_env XIM_PROGRAM fcitx
upsert_env GTK_IM_MODULE fcitx
upsert_env QT_IM_MODULE fcitx
upsert_env GLFW_IM_MODULE fcitx
upsert_env INPUT_METHOD fcitx
upsert_env XMODIFIERS @im=fcitx
upsert_env IMSETTINGS_MODULE fcitx

# ui toolkits
upsert_env QT_QPA_PLATFORM wayland
upsert_env QT_WAYLAND_DISABLE_WINDOWDECORATION 1
upsert_env _JAVA_AWT_WM_NONREPARENTING 1

# screen sharing
upsert_env XDG_CURRENT_DESKTOP sway
