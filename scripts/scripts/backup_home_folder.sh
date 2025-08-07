#!/bin/bash

# Example: ./backup_home_folder.sh external

choice="${1:-local}"

if [ "$choice" != "local" ] && [ "$choice" != "external" ]; then
  echo "Usage: $0 [local|external]"
  exit 1
fi

SOURCE_DIR="$HOME"

# This is my optional choices that can change based on the needs
EXTERNAL_DISK="T7 Touch1"
EXTERNAL_DIR="/media/$USER/$EXTERNAL_DISK"
LOCAL_DIR="/home/$USER/Koofr"

# This is the relative path to the destionation.
BACKUP_RELATIVE_PATH="backups/home/$USER"

if [ "$choice" == "local" ]; then
    DEST_DIR_TEMP="$LOCAL_DIR"
else
    DEST_DIR_TEMP="$EXTERNAL_DIR"
fi

# Check if the directory exists
if [ ! -d "$DEST_DIR_TEMP" ]; then
    echo "Error: Destination directory '$DEST_DIR_TEMP' does not exist."
    exit 1
fi

DEST_DIR="$DEST_DIR_TEMP/$BACKUP_RELATIVE_PATH"

source "$(dirname "$0")/backup_ubuntu_hotkeys.sh"

mkdir -p "$DEST_DIR"
rsync -av --progress --exclude-from="exclude.txt" "$SOURCE_DIR" "$DEST_DIR"
echo "$(date) Synced $SOURCE_DIR to $DEST_DIR" >> "$DEST_DIR/rsync-home.log"
