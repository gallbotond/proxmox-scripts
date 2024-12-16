#!/bin/bash

# Check if the script is being run as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root."
    exit 1
fi

# Step 1: Launch cfdisk to extend the partition
cfdisk

# Inform the user to extend the partition in cfdisk
echo "\nEnsure you extend /dev/sda3 with the available free space using cfdisk. Press Enter to continue once done."
read -r

# Step 2: Resize the physical volume
pvresize /dev/sda3
if [ $? -ne 0 ]; then
    echo "Error: Failed to resize the physical volume /dev/sda3."
    exit 1
fi

# Step 3: Extend the logical volume to use all free space
lvextend -l +100%FREE /dev/ubuntu-vg/ubuntu-lv
if [ $? -ne 0 ]; then
    echo "Error: Failed to extend the logical volume."
    exit 1
fi

# Step 4: Resize the filesystem
resize2fs /dev/mapper/ubuntu--vg-ubuntu--lv
if [ $? -ne 0 ]; then
    echo "Error: Failed to resize the filesystem."
    exit 1
fi

# Final message
echo "\nPartition, logical volume, and filesystem successfully resized."
