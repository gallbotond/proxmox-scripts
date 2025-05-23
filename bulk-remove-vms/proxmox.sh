#!/bin/bash

# Load environment variables from external file
source "$(dirname "$0")/proxmox.env"

# Check that all required variables are set
if [[ -z "$API_URL" || -z "$TOKEN_ID" || -z "$TOKEN_SECRET" ]]; then
  echo "Missing required environment variables. Check proxmox.env."
  exit 1
fi

# Loop through each VMID passed to the script
for vmid in "$@"; do
  echo "Looking up VMID $vmid..."

  # Get the node for the VMID
  node=$(curl -s -k \
    -H "Authorization: PVEAPIToken=$TOKEN_ID=$TOKEN_SECRET" \
    "$API_URL/cluster/resources" | jq -r ".data[] | select(.vmid == $vmid) | .node")

  if [ -z "$node" ]; then
    echo "❌ VMID $vmid not found in cluster"
    continue
  fi

  echo "🗑 Deleting VMID $vmid on node $node..."

  # Issue DELETE request with purge
  response=$(curl -s -k -X DELETE \
    -H "Authorization: PVEAPIToken=$TOKEN_ID=$TOKEN_SECRET" \
    "$API_URL/nodes/$node/qemu/$vmid?purge=1")

  echo "✅ VMID $vmid delete request submitted."
done
