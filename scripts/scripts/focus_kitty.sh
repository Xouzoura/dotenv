#!/bin/bash
# Requires: https://github.com/lucaswerkmeister/activate-window-by-title, busctl, installed https://extensions.gnome.org/extension/5021/activate-window-by-title/

# temp, replace kitty with gnome till kitty is fixed.
# gnome-terminal
if pgrep -f "gnome-terminal" > /dev/null
then
    busctl --user call \
    org.gnome.Shell \
    /de/lucaswerkmeister/ActivateWindowByTitle \
    de.lucaswerkmeister.ActivateWindowByTitle \
    activateByWmClass \
    s 'org.gnome.Terminal'
else
    gnome-terminal &
fi

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
