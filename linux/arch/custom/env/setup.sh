#!/bin/sh

echo "Configuring environment"

# default software
grep -qF 'EDITOR="/usr/bin/nvim"' /etc/environment || echo 'EDITOR="/usr/bin/nvim"' | sudo tee -a /etc/environment > /dev/null

# firefox
grep -qF 'MOZ_ENABLE_WAYLAND=1' /etc/environment || echo 'MOZ_ENABLE_WAYLAND=1' | sudo tee -a /etc/environment > /dev/null

# fcitx
grep -qF 'XIM=fcitx' /etc/environment || echo 'XIM=fcitx' | sudo tee -a /etc/environment > /dev/null
grep -qF 'XIM_PROGRAM=fcitx' /etc/environment || echo 'XIM_PROGRAM=fcitx' | sudo tee -a /etc/environment > /dev/null
grep -qF 'GTK_IM_MODULE=fcitx' /etc/environment || echo 'GTK_IM_MODULE=fcitx' | sudo tee -a /etc/environment > /dev/null
grep -qF 'QT_IM_MODULE=fcitx' /etc/environment || echo 'QT_IM_MODULE=fcitx' | sudo tee -a /etc/environment > /dev/null
grep -qF 'GLFW_IM_MODULE=fcitx' /etc/environment || echo 'GLFW_IM_MODULE=fcitx' | sudo tee -a /etc/environment > /dev/null
grep -qF 'INPUT_METHOD=fcitx' /etc/environment || echo 'INPUT_METHOD=fcitx' | sudo tee -a /etc/environment > /dev/null
grep -qF 'XMODIFIERS=@im=fcitx' /etc/environment || echo 'XMODIFIERS=@im=fcitx' | sudo tee -a /etc/environment > /dev/null
grep -qF 'IMSETTINGS_MODULE=fcitx' /etc/environment || echo 'IMSETTINGS_MODULE=fcitx' | sudo tee -a /etc/environment > /dev/null

# ui toolkits
grep -qF 'QT_QPA_PLATFORM=wayland' /etc/environment || echo 'QT_QPA_PLATFORM=wayland' | sudo tee -a /etc/environment > /dev/null
grep -qF 'QT_WAYLAND_DISABLE_WINDOWDECORATION="1"' /etc/environment || echo 'QT_WAYLAND_DISABLE_WINDOWDECORATION="1"' | sudo tee -a /etc/environment > /dev/null
grep -qF '_JAVA_AWT_WM_NONREPARENTING=1' /etc/environment || echo '_JAVA_AWT_WM_NONREPARENTING=1' | sudo tee -a /etc/environment > /dev/null

# screen sharing
grep -qF 'XDG_CURRENT_DESKTOP=sway' /etc/environment || echo 'XDG_CURRENT_DESKTOP=sway' | sudo tee -a /etc/environment > /dev/null
