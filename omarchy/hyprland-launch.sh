#!/usr/bin/env bash
# ------------------------------------------------------------------------------
# hyprland-launch.sh — auto-detect DisplayLink / multi-GPU support
#
# Purpose:
#   Detects all /dev/dri/card* devices and exports WLR_DRM_DEVICES so Hyprland
#   can use both the integrated GPU and the DisplayLink (EVDI) card.
# ------------------------------------------------------------------------------

set -euo pipefail

# --- Detect DRM devices -------------------------------------------------------
mapfile -t DRM_CARDS < <(ls /dev/dri/card* 2>/dev/null | sort -V)
if [[ ${#DRM_CARDS[@]} -eq 0 ]]; then
  echo "❌ No DRM devices found under /dev/dri/" >&2
  exec Hyprland
fi

# --- Identify the primary GPU (integrated) ------------------------------------
# Usually card0 or card2 for Intel/NVIDIA hybrids
PRIMARY_GPU=${DRM_CARDS[0]}

# --- Include DisplayLink / EVDI cards ----------------------------------------
EXTRA_CARDS=()
for c in "${DRM_CARDS[@]}"; do
  if [[ "$c" != "$PRIMARY_GPU" ]]; then
    if udevadm info -q property -n "$c" | grep -qi 'displaylink\|evdi'; then
      EXTRA_CARDS+=("$c")
    fi
  fi
done

# --- Build WLR_DRM_DEVICES string ---------------------------------------------
if [[ ${#EXTRA_CARDS[@]} -gt 0 ]]; then
  export WLR_DRM_DEVICES="${PRIMARY_GPU}:$(IFS=:; echo "${EXTRA_CARDS[*]}")"
  echo "🖥️  Multi-GPU detected → WLR_DRM_DEVICES=${WLR_DRM_DEVICES}"
else
  export WLR_DRM_DEVICES="${PRIMARY_GPU}"
  echo "🖥️  Single GPU → ${PRIMARY_GPU}"
fi

# --- Launch Hyprland ----------------------------------------------------------
exec Hyprland

