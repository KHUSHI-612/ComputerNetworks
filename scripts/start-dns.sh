#!/usr/bin/env bash
# Mac 1 — start private DNS (requires admin for port 53)
set -euo pipefail
# shellcheck disable=SC1091
source "$(dirname "$0")/env.sh"

if grep -q 'EDGE_IP' "$DNSMASQ_CONF"; then
  echo "Replace EDGE_IP in dns/dnsmasq.conf with Mac 2's real IP first." >&2
  exit 1
fi

echo "Starting dnsmasq with $DNSMASQ_CONF"
# Homebrew dnsmasq often needs sudo for :53
exec sudo dnsmasq --conf-file="$DNSMASQ_CONF" --no-daemon
