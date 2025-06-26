#!/bin/bash
set -e

STABLE=false

for arg in "$@"; do
    if [ "$arg" == "--stable" ]; then
        STABLE=true
        break
    fi
done

mkdir -p ~/.local/bin

if [[ "$STABLE" == true ]]; then
    echo "Downloading latest **stable** Neovim AppImage..."
    curl -L -o ~/.local/bin/nvim-stable.appimage https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.appimage
    chmod +x ~/.local/bin/nvim-stable.appimage
    mv -f ~/.local/bin/nvim-stable.appimage ~/.local/bin/nvims
    echo "Setting up symlink: vis → ~/.local/bin/nvims (stable)"
    echo "Set the ~/.local/bin/nvims for version {$(nvims -V1 -v)}"
else
    echo "Downloading latest **nightly** Neovim AppImage..."
    curl -L -o ~/.local/bin/nvim-nightly.appimage https://github.com/neovim/neovim/releases/download/nightly/nvim-linux-x86_64.appimage
    chmod +x ~/.local/bin/nvim-nightly.appimage
    mv -f ~/.local/bin/nvim-nightly.appimage ~/.local/bin/nvimn
    echo "Set the ~/.local/bin/nvimn for version {$(nvimn -V1 -v)}"
fi

echo "✅ Done!"

