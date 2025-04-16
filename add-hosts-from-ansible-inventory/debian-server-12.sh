#!/bin/bash

# Check if the inventory file is provided as an argument
if [[ $# -ne 1 ]]; then
    echo "Usage: $0 <inventory_file>"
    exit 1
fi

INVENTORY_FILE="$1"

# Check if the file exists
if [[ ! -f "$INVENTORY_FILE" ]]; then
    echo "Error: Inventory file not found at $INVENTORY_FILE"
    exit 1
fi

# Create a backup directory if it doesn't exist
BACKUP_DIR="/etc/hosts.bk"
sudo mkdir -p "$BACKUP_DIR"

# Find the next available backup filename
INDEX=1
while [[ -f "$BACKUP_DIR/hosts.bk$INDEX" ]]; do
    ((INDEX++))
done
BACKUP_FILE="$BACKUP_DIR/hosts.bk$INDEX"

# Backup the original /etc/hosts file
sudo cp /etc/hosts "$BACKUP_FILE"
echo "Backup created at $BACKUP_FILE"

COMMENT="# Homelab entries"
# Add a single comment before the new entries section
if ! grep -q "$COMMENT" /etc/hosts; then
    echo -e "\n$COMMENT" | sudo tee -a /etc/hosts > /dev/null
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