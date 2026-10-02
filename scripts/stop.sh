#!/usr/bin/env bash
# Stop helpers (best-effort)
set -euo pipefail
TARGET="${1:-all}"

stop_dns() {
  echo "Stopping dnsmasq..."
  sudo pkill -f 'dnsmasq --conf-file' 2>/dev/null || sudo brew services stop dnsmasq 2>/dev/null || true
}

stop_edge() {
  echo "Stopping nginx..."
  sudo nginx -s stop 2>/dev/null || sudo pkill nginx 2>/dev/null || true
}

stop_backends() {
  echo "Stopping backend python processes..."
  pkill -f 'python app.py' 2>/dev/null || true
  pkill -f 'backend/app.py' 2>/dev/null || true
}

case "$TARGET" in
  dns) stop_dns ;;
  edge) stop_edge ;;
  backend|backends) stop_backends ;;
  all)
    stop_backends
    stop_edge
    stop_dns
    ;;
  *)
    echo "Usage: $0 [dns|edge|backends|all]" >&2
    exit 1
    ;;
esac
echo "Done ($TARGET)."
