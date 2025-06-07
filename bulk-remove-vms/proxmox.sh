#!/bin/bash

# Load environment variables from the same directory as this script
source "$(dirname "$0")/proxmox.env"

# Check required variables
if [[ -z "$API_URL" || -z "$TOKEN_ID" || -z "$TOKEN_SECRET" ]]; then
  echo "Missing required environment variables. Check proxmox.env."
  exit 1
fi

for vmid in "$@"; do
  echo "🔍 Looking up VMID $vmid..."

  # Get VM info
  vm_info=$(curl -s -k \
    -H "Authorization: PVEAPIToken=$TOKEN_ID=$TOKEN_SECRET" \
    "$API_URL/cluster/resources" | jq -r ".data[] | select(.vmid == $vmid)")

  if [ -z "$vm_info" ]; then
    echo "⚠️  VMID $vmid not found in cluster (already deleted?)"
    continue
  fi

  node=$(echo "$vm_info" | jq -r '.node')
  status=$(echo "$vm_info" | jq -r '.status')

  echo "📦 VMID $vmid is on node '$node' and is currently '$status'."

  # If the VM is running, ask for confirmation
  if [[ "$status" == "running" ]]; then
    read -p "⚠️  VM $vmid is running. Do you want to stop and delete it? (y/n): " confirm
    if [[ "$confirm" != "y" ]]; then
      echo "⏭️  Skipping VMID $vmid"
      continue
    fi

    echo "🛑 Stopping VMID $vmid on $node..."
    curl -s -k -X POST \
      -H "Authorization: PVEAPIToken=$TOKEN_ID=$TOKEN_SECRET" \
      "$API_URL/nodes/$node/qemu/$vmid/status/stop" > /dev/null

    echo "⏳ Waiting for VM to stop..."
    # Poll until status is not 'running'
    for i in {1..10}; do
      sleep 2
      status_check=$(curl -s -k \
        -H "Authorization: PVEAPIToken=$TOKEN_ID=$TOKEN_SECRET" \
        "$API_URL/cluster/resources" | jq -r ".data[] | select(.vmid == $vmid) | .status")
      [[ "$status_check" != "running" ]] && break
    done
  fi

  echo "🗑 Deleting VMID $vmid on node $node..."
  curl -s -k -X DELETE \
    -H "Authorization: PVEAPIToken=$TOKEN_ID=$TOKEN_SECRET" \
    "$API_URL/nodes/$node/qemu/$vmid?purge=1" > /dev/null

  sleep 2

  # Confirm deletion
  exists=$(curl -s -k \
    -H "Authorization: PVEAPIToken=$TOKEN_ID=$TOKEN_SECRET" \
    "$API_URL/cluster/resources" | jq ".data[] | select(.vmid == $vmid)")

  if [ -z "$exists" ]; then
    echo "✅ VMID $vmid successfully deleted."
  else
    echo "❌ VMID $vmid still exists! Deletion may have failed."
  fi

  echo ""
done
