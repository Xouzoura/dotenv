#!/bin/bash

SOURCE_DIR="$HOME"
DEFAULT_DIR="/home/$USER/Koofr/backups/home/$USER"
EXTERNAL_DISK="T7 Touch"
EXTERNAL_DIR="/media/$USER/$EXTERNAL_DISK/backups/home/$USER"
if [ $# -eq 0 ]; then
    # Local
    DEST_DIR="$DEFAULT_DIR"
else
    # External
    DEST_DIR="$EXTERNAL_DIR"
fi
mkdir -p "$DEST_DIR"
rsync -av --progress --exclude-from="exclude.txt" "$SOURCE_DIR" "$DEST_DIR"
echo "$(date) Synced $SOURCE_DIR to $DEST_DIR" >> "$DEST_DIR/rsync-home.log"
