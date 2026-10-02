#!/usr/bin/env bash
# Controlled failure scenarios for demos / Phase 2
set -euo pipefail
# shellcheck disable=SC1091
source "$(dirname "$0")/env.sh"

usage() {
  cat <<EOF
Usage: $0 <scenario>

  stop-backend-a     Stop Backend A (expect traffic only on B if HA configured)
  stop-backend-b     Stop Backend B
  stop-both-backends Stop A and B (expect 502 at edge)
  stop-dns           Stop primary dnsmasq (Phase 2: backup DNS should still work)
  wrong-dns-hint     Print how to set a client to a wrong DNS (manual)
  restore-backends   Reminder to restart backends on Mac 3/4

EOF
}

case "${1:-}" in
  stop-backend-a)
    echo "Stopping processes on port ${BACKEND_A_PORT} (run on Mac 3)..."
    lsof -ti tcp:"${BACKEND_A_PORT}" | xargs kill 2>/dev/null || true
    ;;
  stop-backend-b)
    echo "Stopping processes on port ${BACKEND_B_PORT} (run on Mac 4)..."
    lsof -ti tcp:"${BACKEND_B_PORT}" | xargs kill 2>/dev/null || true
    ;;
  stop-both-backends)
    "$0" stop-backend-a
    "$0" stop-backend-b
    echo "Expect 502 Bad Gateway from nginx."
    ;;
  stop-dns)
    "$(dirname "$0")/stop.sh" dns
    echo "If backup DNS is configured on clients, dig should still resolve."
    ;;
  wrong-dns-hint)
    cat <<EOF
On a client Mac: System Settings → Network → DNS → set a bogus resolver
(e.g. 127.0.0.1) while LAN ping still works. dig ${DOMAIN} fails → DNS vs IP
layers are independent. Restore DNS to ${DNS_IP} afterwards.
EOF
    ;;
  restore-backends)
    echo "On Mac 3: ./scripts/start-backend.sh A"
    echo "On Mac 4: ./scripts/start-backend.sh B"
    ;;
  *)
    usage
    exit 1
    ;;
esac
