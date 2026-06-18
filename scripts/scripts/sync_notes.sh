#!/usr/bin/env bash
set -e

cd /home/xouzoura/vaults/notes || exit 1

git pull --rebase --autostash || true
git add -A
git commit -m "autosync $(date -Iseconds)" || true
git push || true
