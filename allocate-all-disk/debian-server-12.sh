#!/bin/bash
sudo apt install parted -y
sudo parted /dev/sda
sudo pvresize /dev/sda5
sudo lvresize -r -l +100%FREE /dev/mapper/debian12--vg-root
