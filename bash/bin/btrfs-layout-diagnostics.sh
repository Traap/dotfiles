#!/usr/bin/env bash

set -u
set -o pipefail

log_file="./btrfs-layout-diagnostics.log"
mount_point="/mnt/btrfs-root"
device="/dev/mapper/root"
mounted_by_script=0

exec > >(tee "$log_file") 2>&1

run_command() {
  printf '\n$'
  printf ' %q' "$@"
  printf '\n'
  "$@"
  status=$?
  if (( status != 0 )); then
    printf '[exit status: %d]\n' "$status"
  fi
  return 0
}

cleanup() {
  if (( mounted_by_script == 1 )); then
    printf '\nUnmounting %s\n' "$mount_point"
    sudo umount "$mount_point"
  fi
}

trap cleanup EXIT INT TERM

printf 'Btrfs layout diagnostics\n'
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

run_command sudo mkdir -p "$mount_point"

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

run_command findmnt "$mount_point"
run_command sudo btrfs filesystem show "$mount_point"
run_command sudo btrfs subvolume get-default "$mount_point"
run_command sudo btrfs subvolume list -t "$mount_point"
run_command sudo find "$mount_point" -maxdepth 5 -type d -path '*/.snapshots/*/snapshot'

printf '\nDiagnostics saved to %s\n' "$log_file"
