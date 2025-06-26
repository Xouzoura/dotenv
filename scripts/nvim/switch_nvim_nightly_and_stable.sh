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
  NEW_ALIAS='alias nvim="nvims"'
  OLD_ALIAS='alias nvim="nvimn"'
elif [ "$choice" == "nightly" ]; then
  NEW_ALIAS='alias nvim="nvimn"'
  OLD_ALIAS='alias nvim="nvims"'
fi

# Escape for sed
NEW_ALIAS_ESCAPED=$(printf '%s\n' "$NEW_ALIAS" | sed 's/[\/&]/\\&/g')
OLD_ALIAS_ESCAPED=$(printf '%s\n' "$OLD_ALIAS" | sed 's/[\/&]/\\&/g')

ZSHRC="$HOME/.zshrc"

# Comment out the OLD_ALIAS (even if it's not commented)
sed -i "/^\s*${OLD_ALIAS_ESCAPED}/ s/^/#/" "$ZSHRC"

# Uncomment the NEW_ALIAS if commented
sed -i "/^\s*#\s*${NEW_ALIAS_ESCAPED}/ s/^#\s*//" "$ZSHRC"

echo "Updated ~/.zshrc with: $NEW_ALIAS and commented out: $OLD_ALIAS. Reload your shell by running: 'source ~/.zshrc' . Done!"
