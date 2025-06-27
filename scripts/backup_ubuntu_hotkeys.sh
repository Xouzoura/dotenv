#!/bin/bash

# Get list of custom keybinding paths
KEYS=$(gsettings get org.gnome.settings-daemon.plugins.media-keys custom-keybindings | tr -d "[],'")
FILE="$HOME/packages/custom_keys.json"

echo "[" > FILE

for key in $KEYS; do
  KEY_PATH="org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$key"
  NAME=$(gsettings get "$KEY_PATH" name)
  CMD=$(gsettings get "$KEY_PATH" command)
  BIND=$(gsettings get "$KEY_PATH" binding)

  echo "  {" >> $FILE
  echo "    \"path\": \"$key\"," >> $FILE
  echo "    \"name\": $NAME," >> $FILE
  echo "    \"command\": $CMD," >> $FILE
  echo "    \"binding\": $BIND" >> $FILE
  echo "  }," >> $FILE
done

# Remove trailing comma and close JSON array
sed -i '$ s/},/}/' $FILE
echo "]" >> $FILE

echo "✅ Exported to $FILE"
