#!/bin/bash

# Check if the script is being run as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root."
    exit 1
fi

# Define the file path
FILE_PATH="/usr/share/javascript/proxmox-widget-toolkit/proxmoxlib.js"

# Check if the file exists
if [ ! -f "$FILE_PATH" ]; then
    echo "Error: File $FILE_PATH not found."
    exit 1
fi

# Replace the text
sed -i 's/Ext\.Msg\.show({/void ({ \/\/Ext.Msg.show({/g' "$FILE_PATH"

# Check if the replacement was successful
if [ $? -eq 0 ]; then
    echo "Replacement successful."
else
    echo "Error: Replacement failed."
    exit 1
fi



# Restart the pveproxy service
systemctl restart pveproxy

# Check if the service restart was successful
if [ $? -eq 0 ]; then
    echo "pveproxy service restarted successfully."
else
    echo "Error: Failed to restart pveproxy service."
    exit 1
fi