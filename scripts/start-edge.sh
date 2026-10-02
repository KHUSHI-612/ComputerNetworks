#!/usr/bin/env bash
# Mac 2 — validate and (re)load nginx with team edge config
set -euo pipefail
# shellcheck disable=SC1091
source "$(dirname "$0")/env.sh"

if grep -Eq 'BACKEND_[AB]_IP' "$NGINX_CONF"; then
  echo "Replace BACKEND_A_IP / BACKEND_B_IP in edge/team.conf first." >&2
  exit 1
fi

echo "Test nginx config, then reload."
sudo nginx -t
sudo nginx -s reload || sudo nginx
echo "Edge should be listening on :${EDGE_HTTPS_PORT}"
