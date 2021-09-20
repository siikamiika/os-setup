#!/bin/sh

echo "Configuring environment"
grep -qF 'EDITOR="/usr/bin/nvim"' /etc/environment || echo 'EDITOR="/usr/bin/nvim"' | sudo tee -a /etc/environment > /dev/null
grep -qF 'MOZ_ENABLE_WAYLAND=1' /etc/environment || echo 'MOZ_ENABLE_WAYLAND=1' | sudo tee -a /etc/environment > /dev/null
grep -qF 'GTK_IM_MODULE=fcitx' /etc/environment || echo 'GTK_IM_MODULE=fcitx' | sudo tee -a /etc/environment > /dev/null
grep -qF 'QT_IM_MODULE=fcitx' /etc/environment || echo 'QT_IM_MODULE=fcitx' | sudo tee -a /etc/environment > /dev/null
grep -qF 'XMODIFIERS=@im=fcitx' /etc/environment || echo 'XMODIFIERS=@im=fcitx' | sudo tee -a /etc/environment > /dev/null
grep -qF 'QT_QPA_PLATFORM=wayland' /etc/environment || echo 'QT_QPA_PLATFORM=wayland' | sudo tee -a /etc/environment > /dev/null
grep -qF 'QT_WAYLAND_DISABLE_WINDOWDECORATION="1"' /etc/environment || echo 'QT_WAYLAND_DISABLE_WINDOWDECORATION="1"' | sudo tee -a /etc/environment > /dev/null
grep -qF '_JAVA_AWT_WM_NONREPARENTING=1' /etc/environment || echo '_JAVA_AWT_WM_NONREPARENTING=1' | sudo tee -a /etc/environment > /dev/null
