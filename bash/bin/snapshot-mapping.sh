#!/usr/bin/env bash

set -u
set -o pipefail

log_file="./snapshot-mapping.log"
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

printf 'Snapshot and boot mapping diagnostics\n'
printf 'Generated: %s\n' "$(date --iso-8601=seconds)"
printf 'Device: %s\n' "$device"
printf 'Mount point: %s\n' "$mount_point"

if [[ ! -e "$device" ]]; then
  printf '\nERROR: %s does not exist.\n' "$device"
  exit 1
fi

if ! sudo -v; then
  printf '\nERROR: sudo authentication failed.\n'
  exit 1
fi

sudo mkdir -p "$mount_point"

if findmnt --mountpoint "$mount_point" >/dev/null 2>&1; then
  printf '\n%s is already mounted; the script will not unmount it.\n' "$mount_point"
else
  printf '\nMounting Btrfs top-level subvolume read-only.\n'
  if sudo mount -o ro,subvolid=5 "$device" "$mount_point"; then
    mounted_by_script=1
  else
    printf '\nERROR: Could not mount the Btrfs top-level subvolume.\n'
    exit 1
  fi
fi

printf '\n===== MOUNT DETAILS =====\n'
findmnt "$mount_point"

printf '\n===== SNAPSHOT METADATA =====\n'
found_metadata=0
for info_file in "$mount_point"/@/.snapshots/*/info.xml; do
  if [[ -f "$info_file" ]]; then
    found_metadata=1
    printf '\n--- %s ---\n' "$info_file"
    sudo cat "$info_file"
  fi
done
if (( found_metadata == 0 )); then
  printf 'No snapshot info.xml files found.\n'
fi

printf '\n===== ROOT FSTAB =====\n'
if [[ -f "$mount_point/@/etc/fstab" ]]; then
  sudo cat "$mount_point/@/etc/fstab"
else
  printf 'Not found: %s/@/etc/fstab\n' "$mount_point"
fi

printf '\n===== BOOTLOADER SUBVOLUME SETTINGS =====\n'
boot_paths=()
[[ -d /boot/loader/entries ]] && boot_paths+=(/boot/loader/entries)
[[ -d /boot/grub ]] && boot_paths+=(/boot/grub)

if (( ${#boot_paths[@]} == 0 )); then
  printf 'No systemd-boot or GRUB configuration directories found.\n'
else
  sudo grep -R -n -E 'rootflags|subvol' "${boot_paths[@]}" ||
    printf 'No rootflags or subvol settings found in bootloader configuration.\n'
fi

printf '\nDiagnostics saved to %s\n' "$log_file"
