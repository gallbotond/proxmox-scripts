#!/bin/bash

# Backup the original /etc/hosts file
sudo cp /etc/hosts /etc/hosts.bak

# Ask the user for the inventory file path
read -p "Enter the path to the inventory file: " INVENTORY_FILE

# Check if the file exists
if [[ ! -f "$INVENTORY_FILE" ]]; then
    echo "Error: Inventory file not found at $INVENTORY_FILE"
    exit 1
fi

# Parse the inventory file and add entries to /etc/hosts
while IFS= read -r line; do
    # Skip empty lines and comments
    [[ -z "$line" || "$line" =~ ^\; ]] && continue

    # Extract hostname and IP address
    if [[ "$line" =~ ^([a-zA-Z0-9_-]+)[[:space:]]+ansible_host=([0-9.]+) ]]; then
        HOSTNAME="${BASH_REMATCH[1]}"
        IP="${BASH_REMATCH[2]}"
        ENTRY="$IP $HOSTNAME.lan"

        # Check if the entry already exists in /etc/hosts
        if grep -q "$ENTRY" /etc/hosts; then
            echo "Duplicate entry found: $ENTRY"
        else
            echo "$ENTRY" | sudo tee -a /etc/hosts > /dev/null
        fi
    fi
done < "$INVENTORY_FILE"

echo "Hosts file update completed."