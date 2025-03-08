#!/bin/bash
# Requires: https://github.com/lucaswerkmeister/activate-window-by-title, busctl, installed https://extensions.gnome.org/extension/5021/activate-window-by-title/

if pgrep -x "firefox" > /dev/null
then
    busctl --user call \
        org.gnome.Shell \
        /de/lucaswerkmeister/ActivateWindowByTitle \
        de.lucaswerkmeister.ActivateWindowByTitle \
        activateBySubstring \
        s 'Firefox'
else
    # Optionally, start Firefox if it’s not open
    firefox &
fi
