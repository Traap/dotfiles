#!/usr/bin/env bash
#
# thinkpad-network.sh — Auto-detect wired interface and apply DNS domain
# Safe for user-level systemd service.  No sudo required.
#

set -euo pipefail

AD_DOMAIN="ent.co.ventura.ca.us"

# Detect the active wired interface:
detect_iface() {
  # Prefer UP Ethernet interfaces (skip loopback, docker, virtual)
  local iface
  iface=$(ip -o link show up | awk -F': ' '/enp|eth/ && $2 !~ /docker|vir|veth|br/ {print $2; exit}')
  echo "$iface"
}

apply_domain() {
  local iface="$1"
  echo "Applying search domain $AD_DOMAIN to $iface"
  resolvectl domain "$iface" "$AD_DOMAIN" || echo "Warning: failed to apply domain to $iface"
}

remove_domain() {
  local iface="$1"
  echo "Removing search domain $AD_DOMAIN from $iface"
  resolvectl domain "$iface" "" || true
}

main() {
  local action="${1:-}"
  local iface
  iface=$(detect_iface)

  if [[ -z "$iface" ]]; then
    echo "No active wired interface found. Exiting."
    exit 0
  fi

  case "$action" in
    start)
      if resolvectl status "$iface" &>/dev/null; then
        apply_domain "$iface"
      else
        echo "Interface $iface not ready; skipping domain assignment"
      fi
      ;;
    stop)
      remove_domain "$iface"
      ;;
    *)
      echo "Usage: $0 {start|stop}"
      exit 1
      ;;
  esac
}

main "$@"
