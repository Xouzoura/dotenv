#!/bin/bash
set -e

# Default usage: 
# ./switch_nvim_nightly_and_stable.sh nightly
# ./switch_nvim_nightly_and_stable.sh stable (default)

choice="${1:-stable}"

if [ "$choice" != "stable" ] && [ "$choice" != "nightly" ]; then
  echo "Usage: $0 [stable|nightly]"
  exit 1
fi
if [ "$choice" == "stable" ]; then
  rm ~/.local/bin/nvim
  cp ~/.local/bin/nvims ~/.local/bin/nvim
  echo "✅ Copied STABLE (~/.local/bin/nvims) → ~/.local/bin/nvim"
elif [ "$choice" == "nightly" ]; then
  rm ~/.local/bin/nvim
  cp ~/.local/bin/nvimn ~/.local/bin/nvim
  echo "✅ Copied NIGHTLY (~/.local/bin/nvimn) → ~/.local/bin/nvim"
fi

# if [ "$choice" == "stable" ]; then
#   cp ~/.local/bin/nvims ~/.local/bin/nvim
#   # NEW_ALIAS='alias nvim="nvims"'
#   # OLD_ALIAS='alias nvim="nvimn"'
#   echo "Copying bin of STABLE ~.local/bin/nvims as ~/.local/bin/nvim"
# elif [ "$choice" == "nightly" ]; then
#   cp ~/.local/bin/nvimn ~/.local/bin/nvim
#   # NEW_ALIAS='alias nvim="nvimn"'
#   # OLD_ALIAS='alias nvim="nvims"'
#   echo "Copying bin of NIGHTLY ~.local/bin/nvimn as ~/.local/bin/nvim"
#   # echo "Copying bin of ~.local/bin/nvim as ~/.local/bin/nvim"
# fi
#
# Escape for sed
# NEW_ALIAS_ESCAPED=$(printf '%s\n' "$NEW_ALIAS" | sed 's/[\/&]/\\&/g')
# OLD_ALIAS_ESCAPED=$(printf '%s\n' "$OLD_ALIAS" | sed 's/[\/&]/\\&/g')
#
# ZSHRC="$HOME/.zshrc"
#
# # Comment out the OLD_ALIAS (even if it's not commented)
# sed -i "/^\s*${OLD_ALIAS_ESCAPED}/ s/^/#/" "$ZSHRC"
#
# # Uncomment the NEW_ALIAS if commented
# sed -i "/^\s*#\s*${NEW_ALIAS_ESCAPED}/ s/^#\s*//" "$ZSHRC"
#
# echo "Updated ~/.zshrc with: $NEW_ALIAS and commented out: $OLD_ALIAS. Reload your shell by running: 'source ~/.zshrc' . Done!"
