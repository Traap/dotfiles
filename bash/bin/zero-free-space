#!/bin/bash

# Set target fill file
ZEROFILL_FILE="/zerofile"
BUFFER_MB=200  # Leave 200 MB free for safety

echo "[*] Starting to zero free space..."

# Get available free space in MB
FREE_MB=$(df --output=avail / | tail -1)
FREE_MB=$((FREE_MB))

# Calculate safe write size
WRITE_MB=$((FREE_MB - BUFFER_MB))

if [ "$WRITE_MB" -le 0 ]; then
    echo "[!] Not enough free space to proceed. Exiting."
    exit 1
fi

echo "[*] Free space: ${FREE_MB} MB"
echo "[*] Will write: ${WRITE_MB} MB of zeros"

# Fill space with zeros
dd if=/dev/zero of="$ZEROFILL_FILE" bs=1M count="$WRITE_MB" status=progress

# Sync and remove the zero file
sync
rm -f "$ZEROFILL_FILE"

echo "[*] Zeroing complete. Free space has been sanitized."

