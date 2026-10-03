#!/bin/bash
# Requires: https://github.com/lucaswerkmeister/activate-window-by-title, busctl, installed https://extensions.gnome.org/extension/5021/activate-window-by-title/

# gnome-terminal
# if pgrep -f "gnome-terminal" > /dev/null
# then
#     busctl --user call \
#     org.gnome.Shell \
#     /de/lucaswerkmeister/ActivateWindowByTitle \
#     de.lucaswerkmeister.ActivateWindowByTitle \
#     activateByWmClass \
#     s 'org.gnome.Terminal'
# else
#     gnome-terminal &
# fi

# kitty
# if pgrep -f "kitty" > /dev/null
# then
#     busctl --user call \
#     org.gnome.Shell \
#     /de/lucaswerkmeister/ActivateWindowByTitle \
#     de.lucaswerkmeister.ActivateWindowByTitle \
#     activateByWmClass \
#     s 'kitty'
# else
#     kitty &
# fi

# wezterm
if pgrep -f "wezterm-gui" > /dev/null
then
    busctl --user call \
    org.gnome.Shell \
    /de/lucaswerkmeister/ActivateWindowByTitle \
    de.lucaswerkmeister.ActivateWindowByTitle \
    activateByWmClass \
    s 'org.wezfurlong.wezterm'
else
    wezterm &
fi

