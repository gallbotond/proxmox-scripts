#!/bin/bash

echo "old machine-id"
cat /etc/machine-id

sudo rm /var/lib/dbus/machine-id
sudo rm /etc/machine-id
sudo systemd-machine-id-setup

echo "new machine-id"
cat /etc/machine-id