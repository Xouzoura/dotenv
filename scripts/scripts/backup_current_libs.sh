#!/bin/bash

PACKAGES_DIR="/home/$USER/packages"
mkdir -p $PACKAGES_DIR

# ------------------- PACKAGES --------------------------

# ubuntu (apt installations)
dpkg --get-selections > $PACKAGES_DIR/ubuntu-packages.txt
# snap installations
snap list > $PACKAGES_DIR/snap-packages.txt
# flatpak installations
flatpak list > $PACKAGES_DIR/flatpak-packages.txt
# cargo installations
cat ~/.cargo/.crates.toml > $PACKAGES_DIR/crates-packages.txt

echo "✅ Exported libraries/package state to $PACKAGES_DIR"
