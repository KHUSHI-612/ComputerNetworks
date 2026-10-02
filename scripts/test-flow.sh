#!/usr/bin/env bash
# End-to-end checks from a client Mac (DNS pointed at Mac 1)
set -euo pipefail
# shellcheck disable=SC1091
source "$(dirname "$0")/env.sh"

echo "=== 1. DNS resolution ==="
dig @"$DNS_IP" "$DOMAIN" +short || nslookup "$DOMAIN" "$DNS_IP"

echo "=== 2. HTTPS via domain (not raw IP) ==="
URL="https://${DOMAIN}/"
if [[ "$EDGE_HTTPS_PORT" != "443" ]]; then
  URL="https://${DOMAIN}:${EDGE_HTTPS_PORT}/"
fi
curl -vk "$URL" | head -c 500 || true
echo

echo "=== 3. Load balancing (X-Backend should alternate A/B) ==="
for i in 1 2 3 4 5 6; do
  curl -sk -D - -o /dev/null "$URL" 2>/dev/null | grep -i '^X-Backend' || \
    curl -sk "$URL" | grep -o '"backend": "[AB]"' || true
done

echo "=== 4. Caching / ETag on /api/info ==="
INFO="https://${DOMAIN}/api/info"
[[ "$EDGE_HTTPS_PORT" != "443" ]] && INFO="https://${DOMAIN}:${EDGE_HTTPS_PORT}/api/info"
ETAG=$(curl -sk -D - -o /dev/null "$INFO" | awk -F': ' 'tolower($1)=="etag"{print $2}' | tr -d '\r')
echo "ETag=$ETAG"
curl -sk -D - -o /dev/null -H "If-None-Match: $ETAG" "$INFO" | head -n 5

echo "=== Done ==="
