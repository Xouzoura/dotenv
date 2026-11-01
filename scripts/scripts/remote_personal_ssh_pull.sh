#!/usr/bin/env bash
#
# Pull code + branches from the PERSONAL laptop down to the WORK laptop over SSH.
#   ~/code/primeo/ene-fleet/balena-gateway  <-  personal:~/code/primeo/ene-fleet/balena-gateway
#
#
#   ./scripts/remote_personal_ssh_pull.sh             # fetches current
#   ./scripts/remote_personal_ssh_pull.sh  my-feature # fetch `my-feature`
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

branch="${1:-$(git branch --show-current)}"

[[ -n "$branch" ]] || {
  echo "ERROR: detached HEAD; pass a branch name" >&2
  exit 1
}

echo "Fetching ${branch} from ${REMOTE_URL}"

git fetch "$REMOTE_NAME" \
  "refs/heads/${branch}:refs/remotes/${REMOTE_NAME}/${branch}"

if git show-ref --verify --quiet "refs/heads/${branch}"; then
  git checkout "$branch"
else
  git checkout -b "$branch" "${REMOTE_NAME}/${branch}"
fi

git merge --ff-only "${REMOTE_NAME}/${branch}"
echo "Done."


