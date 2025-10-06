#!/bin/bash

ORIG_DIR=$(pwd)
cd ~/vaults/notes/ || exit

MODE=${1:-push}

if [[ "$MODE" == "pull" ]]; then
    echo "Pulling latest changes..."
    git pull
elif [[ "$MODE" == "push" ]]; then
    git pull
    git commit -am "update"
    git push origin master
    echo "Pushed changes..."
else
    echo "Unknown mode: $MODE"
    echo "Usage: $0 [pull|push]"
fi

cd "$ORIG_DIR" || exit

