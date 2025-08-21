#!/bin/bash

# ------------------------------------------------------------------------
# WARNING: This script will ERASE all data on /dev/sda.
# Be absolutely sure that /dev/sda is your USB device and not your system drive.
# ------------------------------------------------------------------------

DEVICE="/dev/sda"
PART="${DEVICE}1"
LABEL="FastUSB"
MOUNTPOINT="/mnt/usb"

# Confirm with the user
read -rp "Are you 100% sure you want to erase $DEVICE and label it '$LABEL'? Type 'YES' to proceed: " confirm
if [[ "$confirm" != "YES" ]]; then
  echo "Aborted."
  exit 1
fi

echo ">>> Unmounting any mounted partitions on $DEVICE..."
sudo umount -l ${DEVICE}?* 2>/dev/null
sudo udisksctl unmount -b ${DEVICE}?* 2>/dev/null

echo ">>> Refreshing kernel view of $DEVICE..."
sleep 2
sudo partprobe "$DEVICE"

echo ">>> Wiping existing filesystem signatures..."
sudo wipefs -a "$DEVICE"

echo ">>> Creating MBR (msdos) partition table..."
sudo parted -s "$DEVICE" mklabel msdos

echo ">>> Creating single primary partition..."
sudo parted -s "$DEVICE" mkpart primary 0% 100%

# Wait for /dev/sda1 to appear
sleep 3
sudo partprobe "$DEVICE"

if [ ! -b "$PART" ]; then
  echo ">>> ERROR: Partition $PART not found. Aborting."
  exit 1
fi

echo ">>> Formatting $PART as exFAT with label '$LABEL'..."
sudo mkfs.exfat -n "$LABEL" "$PART"

echo ">>> Creating mount point at $MOUNTPOINT..."
sudo mkdir -p "$MOUNTPOINT"

echo ">>> Mounting $PART to $MOUNTPOINT..."
sudo mount "$PART" "$MOUNTPOINT"

echo ">>> Success! USB drive is mounted at $MOUNTPOINT and labeled '$LABEL'"

