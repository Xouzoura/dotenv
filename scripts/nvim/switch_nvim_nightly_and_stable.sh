#!/bin/bash

ZSHRC="$HOME/.zshrc"

if [ "$1" != "stable" ] && [ "$1" != "nightly" ]; then
  echo "Usage: $0 [stable|nightly]"
  exit 1
fi

if [ "$1" == "stable" ]; then
  NEW_ALIAS='alias nvim="nvims"'
  OLD_ALIAS='alias nvim="nvimn"'
elif [ "$1" == "nightly" ]; then
  NEW_ALIAS='alias nvim="nvimn"'
  OLD_ALIAS='alias nvim="nvims"'
fi

# Escape for sed
NEW_ALIAS_ESCAPED=$(printf '%s\n' "$NEW_ALIAS" | sed 's/[\/&]/\\&/g')
OLD_ALIAS_ESCAPED=$(printf '%s\n' "$OLD_ALIAS" | sed 's/[\/&]/\\&/g')

# Comment out the OLD_ALIAS (even if it's not commented)
sed -i "/^\s*${OLD_ALIAS_ESCAPED}/ s/^/#/" "$ZSHRC"

# Uncomment the NEW_ALIAS if commented
sed -i "/^\s*#\s*${NEW_ALIAS_ESCAPED}/ s/^#\s*//" "$ZSHRC"

echo "Updated ~/.zshrc with:"
echo "$NEW_ALIAS"
echo "Reload your shell or run: source ~/.zshrc"
