#!/usr/bin/env bash

set -euo pipefail

DEVICE="/dev/sdb"
LABEL_TYPE="${1:-msdos}"   # default to msdos if not provided

# {{{ Validate input

case "$LABEL_TYPE" in
  msdos|gpt)
    ;;
  *)
    echo "ERROR: Invalid label type '$LABEL_TYPE'"
    echo "Usage: $0 [msdos|gpt]"
    exit 1
    ;;
esac

# -------------------------------------------------------------------------- }}}
# {{{ Tell me what I'm doing.

echo "Using partition label: $LABEL_TYPE"
echo "Target device: $DEVICE"

# -------------------------------------------------------------------------- }}}
# {{{ Safety check

read -rp "WARNING: This will erase all data on $DEVICE. Continue? [y/N]: " confirm
[[ "$confirm" == "y" || "$confirm" == "Y" ]] || exit 1

# -------------------------------------------------------------------------- }}}
# {{{ Create partition

sudo wipefs -a "$DEVICE"

sudo parted "$DEVICE" --script mklabel "$LABEL_TYPE"
sudo parted "$DEVICE" --script mkpart primary fat32 1MiB 100%

# Boot flag only applies to msdos
if [[ "$LABEL_TYPE" == "msdos" ]]; then
  sudo parted "$DEVICE" --script set 1 boot on
fi

sudo mkfs.vfat -F 32 -n USB "${DEVICE}1"

# -------------------------------------------------------------------------- }}}
echo "Done."
