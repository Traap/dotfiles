#!/bin/bash

# WARNING: This will permanently destroy recoverable data.
# Review paths before running.

# ICONS
ICON_CLEAN="🧹"
ICON_DELETE="❌"
ICON_DONE="✅"
ICON_INFO="ℹ️"
ICON_WARNING="⚠️"

# Run with sudo to access all files
if [[ $EUID -ne 0 ]]; then
   echo "$ICON_WARNING This script must be run as root"
   exit 1
fi

echo "$ICON_INFO Starting secure deletion of temporary and log files..."

# Directories to shred files in
TARGET_DIRS=(
  "/tmp"
  "/var/tmp"
  "/var/log"
  "$HOME/.cache"
)

# Loop through each directory
for DIR in "${TARGET_DIRS[@]}"; do
  if [ -d "$DIR" ]; then
    echo "$ICON_CLEAN Removing $DIR"

    # Find files (not dirs), and shred securely
    find "$DIR" -type f -exec shred -vuzn 3 {} \;
  else
    echo "$ICON_INFO Skipping non-existent directory: $DIR"
  fi
done

# Remove old logs (compressed ones too)
echo "$ICON_CLEAN Removing rotated/compressed logs in /var/log"
find /var/log -type f \( -name "*.gz" -o \
                         -name "*.old" -o \
                         -name "*.1" -o \
                         -name "*.log" \) \
                         -exec shred -vuzn 3 {} \;

echo "$ICON_DONE Secure shredding complete."
