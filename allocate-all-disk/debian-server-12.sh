#!/bin/bash

# Ensure the script is run as root
# if [[ $EUID -ne 0 ]]; then
#    echo "This script must be run as root" 
#    exit 1
# fi

# Resize partitions
sudo parted /dev/sda resizepart 2 -1s
sudo parted /dev/sda resizepart 5 -1s

# Update the physical volume
sudo pvresize /dev/sda5

# Resize the logical volume to use all free space
sudo lvresize -r -l +100%FREE /dev/mapper/debian12--vg-root
