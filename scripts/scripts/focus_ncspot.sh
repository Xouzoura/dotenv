#!/bin/bash
# Requires: https://github.com/lucaswerkmeister/activate-window-by-title, busctl, installed https://extensions.gnome.org/extension/5021/activate-window-by-title/
if flatpak ps | grep -q 'io.github.hrkfdn.ncspot';
then
   
    if [ $# -gt 0 ]; then
        echo "Debug: true"
    fi

    busctl --user call \
    org.gnome.Shell \
    /de/lucaswerkmeister/ActivateWindowByTitle \
    de.lucaswerkmeister.ActivateWindowByTitle \
    activateBySubstring \
    s 'ncspot'
else
    if [ $# -gt 0 ]; then
        echo "Debug: false"
    fi
    # gnome-terminal ncspot &
    # gnome-terminal -- bash -c "flatpak run io.github.hrkfdn.ncspot; exec bash" &
    gnome-terminal --title="ncspot" -- bash -c 'flatpak run io.github.hrkfdn.ncspot'
fi
