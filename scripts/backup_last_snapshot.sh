#!/bin/bash
# WARNING: requires sudo ;)

SOURCE_DIR="/timeshift/snapshots"
DEST_DIR="/home/$USER/Koofr/backups/ubuntu-snapshots"

LATEST_SNAPSHOT=$(ls -1 "$SOURCE_DIR" | sort | tail -n 1)

LATEST_PATH="$SOURCE_DIR/$LATEST_SNAPSHOT"

mkdir -p "$DEST_DIR"

rsync -a --delete "$LATEST_PATH/" "$DEST_DIR/$LATEST_SNAPSHOT/"

echo "$(date) Synced $LATEST_SNAPSHOT to $DEST_DIR" >> "$DEST_DIR/rsync-timeshift-latest.log"
