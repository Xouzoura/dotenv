#!/usr/bin/env bash
#
# Pull code + branches from the PERSONAL laptop down to the WORK laptop over SSH.
#   ~/code/primeo/ene-fleet/balena-gateway  <-  personal:~/code/primeo/ene-fleet/balena-gateway
#
#
#   ./scripts/remote_personal_ssh_pull.sh             # fetch all branches, fast-forward the current one
#   ./scripts/remote_personal_ssh_pull.sh  # fetch all, then check out / fast-forward that branch
#
set -euo pipefail

# ---- local repo (from current directory) ------------------------------------
LOCAL_REPO="$(git rev-parse --show-toplevel 2>/dev/null)" \
  || { echo "ERROR: $(pwd) is not inside a git repo" >&2; exit 1; }
cd "$LOCAL_REPO"

# ---- personal-laptop source -------------------------------------------------
REMOTE_NAME="${REMOTE_NAME:-personal}"
REMOTE_USER="${REMOTE_USER:-xouzoura}"
REMOTE_HOST="${REMOTE_HOST:-192.168.1.100}"
REMOTE_SSH="${REMOTE_USER}@${REMOTE_HOST}"

if [[ -n "${REMOTE_PATH:-}" ]]; then
  # explicit override: absolute path on personal
  REMOTE_DIR_EXPR="$(printf '%q' "$REMOTE_PATH")"
  REMOTE_URL="ssh://${REMOTE_SSH}${REMOTE_PATH}"
elif [[ "$LOCAL_REPO" == "$HOME"/* ]]; then
  # same path relative to $HOME (home dirs may differ between laptops)
  REL_PATH="${LOCAL_REPO#"$HOME"/}"
  REMOTE_DIR_EXPR="\"\$HOME\"/$(printf '%q' "$REL_PATH")"
  REMOTE_URL="${REMOTE_SSH}:${REL_PATH}"          # scp-style: relative to remote $HOME
else
  # repo outside $HOME: use the identical absolute path
  REMOTE_DIR_EXPR="$(printf '%q' "$LOCAL_REPO")"
  REMOTE_URL="ssh://${REMOTE_SSH}${LOCAL_REPO}"
fi

# ---- check the repo exists on personal --------
if ! ssh "$REMOTE_SSH" "cd ${REMOTE_DIR_EXPR} 2>/dev/null && git rev-parse --git-dir >/dev/null 2>&1"; then
  echo "ERROR: no git repo at ${REMOTE_SSH}:${REMOTE_DIR_EXPR}" >&2
  echo "       push it first (push_to_personal.sh) or set REMOTE_PATH" >&2
  exit 1
fi

if git remote get-url "$REMOTE_NAME" >/dev/null 2>&1; then
  git remote set-url "$REMOTE_NAME" "$REMOTE_URL"
else
  git remote add "$REMOTE_NAME" "$REMOTE_URL"
fi

echo "Fetching ${REMOTE_URL} -> ${LOCAL_REPO}"
git fetch --prune "$REMOTE_NAME"

target="${1:-}"
if [[ -n "$target" ]]; then
  if git show-ref --verify --quiet "refs/heads/$target"; then
    git checkout "$target"
  elif git show-ref --verify --quiet "refs/remotes/${REMOTE_NAME}/$target"; then
    git checkout -b "$target" "${REMOTE_NAME}/$target"
  else
    echo "ERROR: branch '$target' exists neither locally nor on ${REMOTE_NAME}" >&2
    exit 1
  fi
fi

cur="$(git symbolic-ref --quiet --short HEAD || true)"
[[ -n "$cur" ]] || { echo "detached HEAD; branches fetched, nothing to fast-forward"; exit 0; }

if git rev-parse --verify --quiet "${REMOTE_NAME}/${cur}" >/dev/null; then
  if git merge --ff-only "${REMOTE_NAME}/${cur}"; then
    echo "Fast-forwarded ${cur} -> ${REMOTE_NAME}/${cur}"
  else
    echo "WARN: ${cur} has diverged from ${REMOTE_NAME}/${cur}; merge or rebase manually" >&2
  fi
else
  echo "No ${REMOTE_NAME}/${cur} on personal; other branches fetched only."
fi
echo "Done."


