#!/usr/bin/env bash

set -Eeuo pipefail

device="/dev/mapper/root"
target="/mnt/persistent-root"
old_root_uuid="6e4fa239-34e0-4feb-9de5-b712d0ef0d30"
old_boot_uuid="D1E4-4DEA"
mounted_by_script=0

cleanup() {
  if (( mounted_by_script == 1 )); then
    sudo umount "$target" 2>/dev/null || true
  fi
}

trap cleanup EXIT INT TERM

printf '%s\n' 'This repairs stale filesystem UUIDs in persistent @/etc/fstab.'
printf '%s\n' 'A timestamped backup will be created before editing.'
printf '\nType REPAIR-FSTAB to continue: '
read -r confirmation
if [[ "$confirmation" != "REPAIR-FSTAB" ]]; then
  printf 'Cancelled.\n'
  exit 1
fi

sudo -v

root_uuid=$(findmnt -no UUID /home)
boot_uuid=$(findmnt -no UUID /boot)

if [[ -z "$root_uuid" || -z "$boot_uuid" ]]; then
  printf 'ERROR: unable to determine current filesystem UUIDs.\n' >&2
  exit 1
fi

printf '\nDetected Btrfs UUID: %s\n' "$root_uuid"
printf 'Detected boot UUID:  %s\n' "$boot_uuid"

sudo mkdir -p "$target"
if findmnt --mountpoint "$target" >/dev/null 2>&1; then
  printf 'ERROR: %s is already mounted. Unmount it before retrying.\n' "$target" >&2
  exit 1
fi

sudo mount -o subvol=@ "$device" "$target"
mounted_by_script=1

fstab="$target/etc/fstab"
if [[ ! -f "$fstab" ]]; then
  printf 'ERROR: persistent fstab not found: %s\n' "$fstab" >&2
  exit 1
fi

if ! sudo grep -qF "UUID=$old_root_uuid" "$fstab"; then
  printf 'ERROR: expected stale Btrfs UUID was not found; no changes made.\n' >&2
  exit 1
fi

timestamp=$(date +%Y%m%d-%H%M%S)
backup="$fstab.backup-$timestamp"
sudo cp -a "$fstab" "$backup"

sudo sed -i \
  -e "s/UUID=$old_root_uuid/UUID=$root_uuid/g" \
  -e "s/UUID=$old_boot_uuid/UUID=$boot_uuid/g" \
  "$fstab"

printf '\n===== FSTAB CHANGES =====\n'
sudo diff -u "$backup" "$fstab" || true

printf '\n===== VERIFICATION =====\n'
sudo findmnt --verify --verbose --tab-file "$fstab" || true
printf '\nRemaining stale UUID references:\n'
if sudo grep -n -E "$old_root_uuid|$old_boot_uuid" "$fstab"; then
  printf 'ERROR: stale UUID references remain. Restore %s before rebooting.\n' "$backup" >&2
  exit 1
else
  printf 'None.\n'
fi

printf '\nRepair completed. Backup: %s\n' "$backup"
printf '%s\n' 'Reboot into the normal Linux entry using verbose cmdline options once more.'
