#!/usr/bin/env bash

set -Eeuo pipefail

device="/dev/mapper/root"
target="/mnt/persistent-root"
kernel_pkg="/var/cache/pacman/pkg/linux-7.1.11.arch1-1-x86_64.pkg.tar.zst"
backup_dir="/boot/recovery-backup-20260830-1015"
mounted_target=0
mounted_paths=()

cleanup() {
  local index
  for (( index=${#mounted_paths[@]}-1; index>=0; index-- )); do
    sudo umount "${mounted_paths[index]}" 2>/dev/null || true
  done
  if (( mounted_target == 1 )); then
    sudo umount "$target" 2>/dev/null || true
  fi
}

trap cleanup EXIT INT TERM

printf '%s\n' 'This repairs the persistent @ root after an update was run in OverlayFS.'
printf '%s\n' 'It will install linux 7.1.11 into persistent @ and regenerate boot artifacts.'
printf '%s\n' 'It will not replace or delete any Btrfs snapshots.'
printf '\nType REPAIR to continue: '
read -r confirmation
if [[ "$confirmation" != "REPAIR" ]]; then
  printf 'Cancelled.\n'
  exit 1
fi

sudo -v

if [[ ! -e "$device" ]]; then
  printf 'ERROR: %s does not exist.\n' "$device" >&2
  exit 1
fi
if [[ ! -f "$kernel_pkg" ]]; then
  printf 'ERROR: cached kernel package is missing: %s\n' "$kernel_pkg" >&2
  exit 1
fi
if [[ "$(findmnt -no FSTYPE /)" != "overlay" ]]; then
  printf 'ERROR: this script is intended for the current OverlayFS recovery boot.\n' >&2
  exit 1
fi

sudo mkdir -p "$target"
if findmnt --mountpoint "$target" >/dev/null 2>&1; then
  printf 'ERROR: %s is already mounted. Unmount it before retrying.\n' "$target" >&2
  exit 1
fi

printf '\nMounting persistent @ read-write...\n'
sudo mount -o subvol=@ "$device" "$target"
mounted_target=1

printf 'Backing up current boot artifacts to %s...\n' "$backup_dir"
sudo mkdir -p "$backup_dir"
sudo cp -a /boot/EFI/Linux/omarchy_linux.efi "$backup_dir/"
sudo cp -a /boot/limine.conf "$backup_dir/"

sudo mkdir -p "$target/boot" "$target/var/cache/pacman/pkg"

bind_mount() {
  local source=$1
  local destination=$2
  sudo mount --bind "$source" "$destination"
  mounted_paths+=("$destination")
}

bind_mount /boot "$target/boot"
bind_mount /var/cache/pacman/pkg "$target/var/cache/pacman/pkg"
bind_mount /dev "$target/dev"
bind_mount /proc "$target/proc"
bind_mount /sys "$target/sys"
bind_mount /run "$target/run"

printf '\nPersistent state before repair:\n'
sudo chroot "$target" pacman -Q linux
sudo find "$target/usr/lib/modules" -mindepth 1 -maxdepth 1 -type d -printf '%f\n' | sort -V

printf '\nInstalling the cached 7.1.11 kernel into persistent @...\n'
sudo chroot "$target" pacman -U --noconfirm \
  /var/cache/pacman/pkg/linux-7.1.11.arch1-1-x86_64.pkg.tar.zst

printf '\nVerification after repair:\n'
sudo chroot "$target" pacman -Q linux
sudo find "$target/usr/lib/modules" -mindepth 1 -maxdepth 1 -type d -printf '%f\n' | sort -V
sudo grep -A7 -B2 'Kernel version: 7.1.11-arch1-1' /boot/limine.conf || true
sudo stat -c '%y  %s bytes  %n' /boot/EFI/Linux/omarchy_linux.efi

printf '\nRepair completed. Boot backup: %s\n' "$backup_dir"
printf '%s\n' 'After cleanup, reboot into the normal @ entry—not a snapshot.'
