#!/bin/bash

choice="${1:-local}"

if [ "$choice" != "local" ] && [ "$choice" != "external" ]; then
  echo "Usage: $0 [local|external]"
  exit 1
fi

SOURCE_DIR="$HOME"
LOCAL_DIR="/home/$USER/Koofr/backups/home/$USER"
EXTERNAL_DISK="T7 Touch"
EXTERNAL_DIR="/media/$USER/$EXTERNAL_DISK/backups/home/$USER"
PACKAGES_DIR="/home/$USER/packages"

if [ "$choice" == "local" ]; then
    DEST_DIR="$LOCAL_DIR"
else
    DEST_DIR="$EXTERNAL_DIR"
fi

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

mkdir -p "$DEST_DIR"
rsync -av --progress --exclude-from="exclude.txt" "$SOURCE_DIR" "$DEST_DIR"
echo "$(date) Synced $SOURCE_DIR to $DEST_DIR" >> "$DEST_DIR/rsync-home.log"
