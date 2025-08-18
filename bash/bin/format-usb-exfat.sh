#!/bin/bash

# ------------------------------------------------------------------------
# WARNING: This script will ERASE all data on /dev/sda.
# Make sure /dev/sda is the USB device and not your system drive.
# ------------------------------------------------------------------------

DEVICE="/dev/sda"
PART="${DEVICE}1"
LABEL="FastUSB"
MOUNTPOINT="/mnt/usb"

# Confirm device with user
echo "Are you 100% sure you want to erase $DEVICE and "
echo "label it '$LABEL'? "
read -rp "Type 'YES' to proceed: " confirm
if [[ "$confirm" != "YES" ]]; then
  echo "Aborted."
  exit 1
fi

echo ">>> Unmounting any mounted partitions on $DEVICE..."
sudo umount -l ${DEVICE}?* 2>/dev/null

echo ">>> Wiping filesystem signatures..."
sudo wipefs -a "$DEVICE"

echo ">>> Creating GPT partition table..."
sudo parted -s "$DEVICE" mklabel gpt

echo ">>> Creating single ext4 partition..."
sudo parted -s "$DEVICE" mkpart primary ext4 0% 100%

# Wait for kernel to register new partition
sleep 2

echo ">>> Formatting $PART as ext4 with label '$LABEL'..."
sudo mkfs.exfat -L "$LABEL" "$PART"

echo ">>> Creating mount point: $MOUNTPOINT"
sudo mkdir -p "$MOUNTPOINT"

echo ">>> Mounting $PART to $MOUNTPOINT"
sudo mount "$PART" "$MOUNTPOINT"

echo ">>> Done. USB is mounted at $MOUNTPOINT with label '$LABEL'"

