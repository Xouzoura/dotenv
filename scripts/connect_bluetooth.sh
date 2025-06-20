#!/bin/bash
# Assumes the command knows which are mac addresses :)
MAC_ADDRESS=$1
if [ -z "$MAC_ADDRESS" ]; then
  echo "Usage: $0 <MAC_ADDRESS>"
  exit 1
fi
if bluetoothctl info $MAC_ADDRESS | grep -q "Connected: yes"; then
    echo "Disconnecting from $MAC_ADDRESS"
    bluetoothctl disconnect $MAC_ADDRESS
else
    echo "Connecting to $MAC_ADDRESS"
    bluetoothctl connect $MAC_ADDRESS
fi
