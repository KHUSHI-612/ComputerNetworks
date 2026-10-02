#!/usr/bin/env bash
# Mac 3 or 4 — start backend A or B
set -euo pipefail
ID="${1:-}"
if [[ -z "$ID" ]]; then
  echo "Usage: $0 A|B" >&2
  exit 1
fi
exec "$(dirname "$0")/../backend/run.sh" "$ID"
