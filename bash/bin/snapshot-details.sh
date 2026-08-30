#!/usr/bin/env bash

set -u
set -o pipefail

log_file="./snapshot-details.log"
mount_point="/mnt/btrfs-root"
device="/dev/mapper/root"
mounted_by_script=0

exec > >(tee "$log_file") 2>&1

cleanup() {
  if (( mounted_by_script == 1 )); then
    printf '\nUnmounting %s\n' "$mount_point"
    sudo umount "$mount_point"
  fi
}

trap cleanup EXIT INT TERM

printf 'Snapshot detail diagnostics\n'
printf 'Generated: %s\n' "$(date --iso-8601=seconds)"

if [[ ! -e "$device" ]]; then
  printf 'ERROR: %s does not exist.\n' "$device"
  exit 1
fi

if ! sudo -v; then
  printf 'ERROR: sudo authentication failed.\n'
  exit 1
fi

sudo mkdir -p "$mount_point"
if findmnt --mountpoint "$mount_point" >/dev/null 2>&1; then
  printf '%s is already mounted; it will not be unmounted by this script.\n' "$mount_point"
else
  if sudo mount -o ro,subvolid=5 "$device" "$mount_point"; then
    mounted_by_script=1
  else
    printf 'ERROR: Could not mount the Btrfs top-level subvolume.\n'
    exit 1
  fi
fi

printf '\n===== DEVICE IDENTIFIERS =====\n'
sudo blkid "$device" || true
lsblk -f || true

printf '\n===== ROOT SUBVOLUME =====\n'
sudo btrfs subvolume show "$mount_point/@" || true

printf '\n===== SNAPSHOT CREATION DETAILS =====\n'
mapfile -t snapshots < <(
  sudo find "$mount_point/@/.snapshots" -mindepth 2 -maxdepth 2 \
    -type d -name snapshot -print 2>/dev/null | sort -V
)
for snapshot in "${snapshots[@]}"; do
  printf '\n--- %s ---\n' "$snapshot"
  sudo btrfs subvolume show "$snapshot" || true
done
if (( ${#snapshots[@]} == 0 )); then
  printf 'No snapshot subvolumes found.\n'
fi

printf '\n===== FSTAB COMPARISON =====\n'
roots=("$mount_point/@" "${snapshots[@]}")
for root in "${roots[@]}"; do
  printf '\n--- %s/etc/fstab ---\n' "$root"
  if [[ -f "$root/etc/fstab" ]]; then
    sudo sha256sum "$root/etc/fstab" || true
    sudo grep -n -E '^[^#].*[[:space:]]/[[:space:]]|UUID=|subvol=' "$root/etc/fstab" || true
  else
    printf 'fstab not found\n'
  fi
done

printf '\n===== BOOT FILE INVENTORY =====\n'
sudo find /boot -maxdepth 3 -type f -printf '%p\n' 2>/dev/null | sort || true

printf '\n===== BOOT ROOT AND SUBVOLUME SETTINGS =====\n'
sudo grep -R -n -E 'root=|rootflags|subvol|UUID=' /boot 2>/dev/null ||
  printf 'No matching boot settings found.\n'

printf '\nDiagnostics saved to %s\n' "$log_file"
