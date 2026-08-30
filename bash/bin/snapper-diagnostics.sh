#!/usr/bin/env bash

set -u
set -o pipefail

log_file="./snapper-diagnoistics.log"

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
}

printf 'Snapper/Btrfs diagnostics\n'
printf 'Generated: %s\n' "$(date --iso-8601=seconds)"

run_command findmnt /
run_command findmnt -t btrfs
run_command lsblk -f
run_command sudo btrfs filesystem show
run_command sudo btrfs subvolume list /
run_command sudo btrfs subvolume get-default /
run_command findmnt -no FSTYPE,SOURCE,OPTIONS /

printf '\nDiagnostics saved to %s\n' "$log_file"
