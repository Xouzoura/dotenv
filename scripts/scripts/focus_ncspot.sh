#!/bin/bash
# Requires: https://github.com/lucaswerkmeister/activate-window-by-title, busctl, installed https://extensions.gnome.org/extension/5021/activate-window-by-title/

# TEMPORARY ISSUE WITH NCSPOT BECAUSE OF SPOTIFY LIMITATIONS
if pgrep -x "spotify" > /dev/null
then
    busctl --user call \
    org.gnome.Shell \
    /de/lucaswerkmeister/ActivateWindowByTitle \
    de.lucaswerkmeister.ActivateWindowByTitle \
    activateByWmClass \
    s 'Spotify'
fi

# ORIGINAL
# if pgrep -x "ncspot" > /dev/null
# then
#     busctl --user call \
#     org.gnome.Shell \
#     /de/lucaswerkmeister/ActivateWindowByTitle \
#     de.lucaswerkmeister.ActivateWindowByTitle \
#     activateBySubstring \
#     s 'ncspot'
# else
#     gnome-terminal --title="ncspot" -- bash -c 'ncspot'
# fi
#
