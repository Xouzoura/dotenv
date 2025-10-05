#!/bin/bash
ORIG_DIR=$(pwd)
# Navigate to your repo (optional)
z ~/vaults/notes/
git pull
git commit -am "update"
git push origin master

echo "Pushed changes..."

z $ORIG_DIR
