#!/bin/bash
# WARNING: requires sudo ;)

SOURCE_DIR="/timeshift/snapshots"

DEST_DIR="/home/$USER/Koofr/backups/ubuntu-snapshots"
EXTERNAL_DISK="T7 Touch"
EXTERNAL_DIR="/media/$USER/$EXTERNAL_DISK/backups/ubuntu-snapshots"

if [ $# -eq 0 ]; then
    # Local
    DEST_DIR="$DEFAULT_DIR"
else
    # External
    DEST_DIR="$EXTERNAL_DIR"
fi
LATEST_SNAPSHOT=$(ls -1 "$SOURCE_DIR" | sort | tail -n 1)

LATEST_PATH="$SOURCE_DIR/$LATEST_SNAPSHOT"

mkdir -p "$DEST_DIR"

rsync -a --delete "$LATEST_PATH/" "$DEST_DIR/$LATEST_SNAPSHOT/"

echo "$(date) Synced $LATEST_SNAPSHOT to $DEST_DIR" >> "$DEST_DIR/rsync-timeshift-latest.log"
