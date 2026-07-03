#!/usr/bin/env bash
set -e
if pgrep -a nvim | grep -q "vaults/notes"; then
    echo "[sync] nvim session found, so skipping..."
    exit 0
fi
cd /home/xouzoura/vaults/notes || exit 1
if ! curl -fsS --max-time 3 https://github.com >/dev/null; then
  echo "[sync] no internet, skipping"
  exit 0
fi
git pull --rebase --autostash || true
git add -A
git commit -m "autosync $(date +'%m/%d %H:%M') $(hostname)" || true
git push || true
