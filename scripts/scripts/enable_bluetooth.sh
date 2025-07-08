#!/bin/bash

# Might need sudo only once
# if [[ $EUID -ne 0 ]]; then
#   exec sudo "$0" "$@"
# fi

# Ensure required commands are available
command -v rfkill >/dev/null || { echo "rfkill not found"; exit 1; }
command -v bluetoothctl >/dev/null || { echo "bluetoothctl not found"; exit 1; }
command -v notify-send >/dev/null || { echo "notify-send not found (install libnotify-bin)"; exit 1; }

# Function to enable Bluetooth
enable_bluetooth() {
  rfkill unblock bluetooth
  modprobe btusb
  # systemctl restart bluetooth
  sleep 3
  bluetoothctl power on
  notify-send "Bluetooth" "Bluetooth enabled ✅"
}

# Function to disable Bluetooth
disable_bluetooth() {
  bluetoothctl power off
  rfkill block bluetooth
  # modprobe -r btusb
  # systemctl stop bluetooth
  notify-send "Bluetooth" "Bluetooth disabled ❌"
}

# Determine current state
STATE=$(bluetoothctl show | grep "Powered:" | awk '{print $2}')

if [[ "$STATE" == "yes" ]]; then
  disable_bluetooth
else
  enable_bluetooth
fi
