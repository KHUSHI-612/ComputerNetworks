# Evidence checklist

Drop screenshots under `screenshots/` and Wireshark exports under `pcapng/`.

Large `.pcapng` files are gitignored by default — keep a short capture or link to shared drive if size is an issue.

| Evidence | File suggestion | Phase |
|----------|-----------------|-------|
| Topology / IP inventory | `screenshots/01-topology.png` | 1 |
| Ping mesh | `screenshots/02-ping.png` | 1 |
| dig / nslookup | `screenshots/03-dig.png` | 1 |
| curl HTTPS + headers | `screenshots/04-curl-https.png` | 1 |
| X-Backend A/B | `screenshots/05-load-balance.png` | 1 |
| DNS in Wireshark | `pcapng/dns.pcapng` | 1 |
| TCP handshake | `pcapng/tcp-handshake.pcapng` | 1 |
| TLS handshake | `pcapng/tls-handshake.pcapng` | 1 |
| Cache-Control / 304 | `screenshots/06-caching.png` | 1 |
| Backend failure | `screenshots/07-backend-down.png` | 1/2 |
| Backup DNS / TTL / HA | `screenshots/08-phase2-*.png` | 2 |
