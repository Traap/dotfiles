#!/usr/bin/env bash

set -u
set -o pipefail

log_file="./post-overlay-update-check.log"
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

printf 'Post-OverlayFS update verification\n'
printf 'Generated: %s\n' "$(date --iso-8601=seconds)"

if ! sudo -v; then
  printf 'ERROR: sudo authentication failed.\n'
  exit 1
fi

printf '\n===== CURRENT BOOT =====\n'
findmnt -no TARGET,SOURCE,FSTYPE,OPTIONS /
cat /proc/cmdline
printf 'Running kernel: '
uname -r

printf '\n===== TEMPORARY OVERLAY PACKAGE STATE =====\n'
pacman -Q linux linux-firmware 2>&1 || true
printf '\nOverlay module directories:\n'
find /usr/lib/modules -mindepth 1 -maxdepth 1 -type d -printf '%f\n' 2>/dev/null | sort -V
printf '\nRecent overlay pacman activity:\n'
grep -E '\[ALPM\] (upgraded|installed) (linux|linux-firmware|omarchy|codex)' /var/log/pacman.log 2>/dev/null | tail -40 || true

sudo mkdir -p "$mount_point"
if findmnt --mountpoint "$mount_point" >/dev/null 2>&1; then
  printf '\n%s is already mounted; it will not be unmounted by this script.\n' "$mount_point"
else
  if sudo mount -o ro,subvolid=5 "$device" "$mount_point"; then
    mounted_by_script=1
  else
    printf 'ERROR: Could not mount the Btrfs top-level subvolume.\n'
    exit 1
  fi
fi

printf '\n===== PERSISTENT @ PACKAGE STATE =====\n'
sudo pacman --root "$mount_point/@" \
  --dbpath "$mount_point/@/var/lib/pacman" -Q linux linux-firmware 2>&1 || true
printf '\nPersistent @ module directories:\n'
sudo find "$mount_point/@/usr/lib/modules" -mindepth 1 -maxdepth 1 \
  -type d -printf '%f\n' 2>/dev/null | sort -V
printf '\nRecent persistent @ pacman activity:\n'
sudo grep -E '\[ALPM\] (upgraded|installed) (linux|linux-firmware|omarchy|codex)' \
  "$mount_point/@/var/log/pacman.log" 2>/dev/null | tail -40 || true

printf '\n===== BOOT ARTIFACTS =====\n'
sudo stat -c '%y  %s bytes  %n' /boot/EFI/Linux/omarchy_linux.efi \
  /boot/limine.conf 2>&1 || true
printf '\nNormal-entry kernel information:\n'
sudo sed -n '25,38p' /boot/limine.conf 2>/dev/null || true
printf '\nCurrent UKI checksum:\n'
sudo sha256sum /boot/EFI/Linux/omarchy_linux.efi 2>/dev/null || true

printf '\nDiagnostics saved to %s\n' "$log_file"
