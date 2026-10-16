#!/usr/bin/env bash
#
#   Syncs
#   ~/code/primeo/ene-fleet/balena-gateway  ->  personal:~/code/primeo/ene-fleet/balena-gateway
#
#   scripts/remote_personal_ssh_push.sh                 # push the current branch (+ tags)
#   scripts/remote_personal_ssh_push.sh --all           # push every local branch (+ tags)
#   scripts/remote_personal_ssh_push.sh my-feature      # push a specific branch
#   scripts/remote_personal_ssh_push.sh --with-origin   # also mirror origin/* as origin/<name> on personal
#
# Override target without editing the file:
#   REMOTE_HOST=192.168.1.100 push_to_personal.sh
#   REMOTE_PATH=/some/other/path push_to_personal.sh   # skip the same-path mapping
#
set -euo pipefail

LOCAL_REPO="$(git rev-parse --show-toplevel 2>/dev/null)" \
  || { echo "ERROR: $(pwd) is not inside a git repo" >&2; exit 1; }
cd "$LOCAL_REPO"

REMOTE_NAME="${REMOTE_NAME:-personal}"
REMOTE_USER="${REMOTE_USER:-xouzoura}"
REMOTE_HOST="${REMOTE_HOST:-192.168.1.100}"
REMOTE_SSH="${REMOTE_USER}@${REMOTE_HOST}"

if [[ -n "${REMOTE_PATH:-}" ]]; then
  REMOTE_DIR_EXPR="$(printf '%q' "$REMOTE_PATH")"
  REMOTE_URL="ssh://${REMOTE_SSH}${REMOTE_PATH}"
elif [[ "$LOCAL_REPO" == "$HOME"/* ]]; then
  REL_PATH="${LOCAL_REPO#"$HOME"/}"
  REMOTE_DIR_EXPR="\"\$HOME\"/$(printf '%q' "$REL_PATH")"
  REMOTE_URL="${REMOTE_SSH}:${REL_PATH}"          # scp-style: relative to remote $HOME
else
  REMOTE_DIR_EXPR="$(printf '%q' "$LOCAL_REPO")"
  REMOTE_URL="ssh://${REMOTE_SSH}${LOCAL_REPO}"
fi

mode="current"
with_origin=0
branch=""
for arg in "$@"; do
  case "$arg" in
    --all)         mode="all" ;;
    --with-origin) with_origin=1 ;;
    -*)            echo "Unknown option: $arg" >&2; exit 2 ;;
    *)             mode="branch"; branch="$arg" ;;
  esac
done

# ---- prepare the repo on personal --------------------------------------------
# create the directory, init a repo if missing, and let pushes update the
# checked-out branch (only applied when its working tree is clean)
echo "Preparing ${REMOTE_SSH}:${REMOTE_DIR_EXPR}"
ssh "$REMOTE_SSH" "
  set -e
  mkdir -p ${REMOTE_DIR_EXPR}
  cd ${REMOTE_DIR_EXPR}
  if ! git rev-parse --git-dir >/dev/null 2>&1; then
    git init -q
    echo 'initialised new repo'
  fi
  git config receive.denyCurrentBranch updateInstead
" || { echo "ERROR: could not prepare repo on personal" >&2; exit 1; }

if git remote get-url "$REMOTE_NAME" >/dev/null 2>&1; then
  git remote set-url "$REMOTE_NAME" "$REMOTE_URL"
else
  git remote add "$REMOTE_NAME" "$REMOTE_URL"
fi

echo "Pushing ${LOCAL_REPO} -> ${REMOTE_URL}"
case "$mode" in
  all)
    git push "$REMOTE_NAME" --all ;;
  branch)
    git push "$REMOTE_NAME" "$branch" ;;
  current)
    cur="$(git symbolic-ref --quiet --short HEAD || true)"
    [[ -n "$cur" ]] || { echo "ERROR: detached HEAD; pass a branch name" >&2; exit 1; }
    git push "$REMOTE_NAME" "$cur" ;;
esac

if [[ "$with_origin" -eq 1 ]]; then
  echo "Mirroring origin/* -> ${REMOTE_NAME} origin/*"
  git push "$REMOTE_NAME" 'refs/remotes/origin/*:refs/heads/origin/*' || true
fi

git push "$REMOTE_NAME" --tags || true
echo "Done."

