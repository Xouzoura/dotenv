#!/bin/bash

SOURCE_DIR="$HOME"
DEST_DIR="/home/$USER/Koofr/backups/home/$(whoami)"
mkdir -p "$DEST_DIR"
rsync -av --progress --exclude-from="exclude.txt" "$SOURCE_DIR" "$DEST_DIR"
echo "$(date) Synced $SOURCE_DIR to $DEST_DIR" >> "$DEST_DIR/rsync-home.log"
