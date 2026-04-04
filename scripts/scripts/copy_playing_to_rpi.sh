#!/usr/bin/env bash

LOCAL_FILE="/tmp/nowplaying.cache"
REMOTE="xouzoura@192.168.1.254"
REMOTE_FILE="/tmp/nowplaying.cache"

last_hash=""

while true; do
    if [[ -f "$LOCAL_FILE" ]]; then
        ts=$(cut -d'|' -f1 "$LOCAL_FILE")
        now=$(date +%s)
        age=$((now - ts))

        hash=$(sha256sum "$LOCAL_FILE" | awk '{print $1}')

        if [[ "$age" -lt 60 && "$hash" != "$last_hash" ]]; then
            scp "$LOCAL_FILE" "$REMOTE:$REMOTE_FILE" >/dev/null
            last_hash="$hash"
        fi
    fi
    sleep 5
done
