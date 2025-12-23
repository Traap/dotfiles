#!/usr/bin/env bash
# krenew.sh — Safely renew Kerberos tickets on Active Directory Network
set -euo pipefail

# Detect network by pinging the AD DNS server
if ! ping -c1 -W2 "$AD_DNS1" >/dev/null 2>&1; then
  echo "[krenew] Active Directory network not detected — skipping renewal."
  exit 0
fi

# If we have a ticket, try to renew it
if klist >/dev/null 2>&1; then
  if kinit -R 2>/dev/null; then
    echo "[krenew] Kerberos ticket renewed."
    exit 0
  else
    echo "[krenew] Ticket renewal failed. Manual 'kinit' required."
    exit 1
  fi
else
  echo "[krenew] No active ticket — manual 'kinit' required."
  exit 0
fi
