# Architecture Document — Private Network Service Platform

> Update IP addresses and hostnames before Phase 1 review. Replace `teamX` with your team id.

## 1. Purpose

Build a fully local private service environment so a client can:

1. Resolve `app.teamX.test` / `api.teamX.test` via team DNS (dnsmasq)
2. Connect over HTTPS to the team edge (nginx)
3. Receive JSON from Backend A or Backend B (round-robin)
4. Prove each layer with dig, curl, and Wireshark

## 2. Network topology

```
                    +------------------+
                    |  Mac 1 — DNS     |
                    |  dnsmasq :53     |
                    |  (test client)   |
                    +--------+---------+
                             | DNS (UDP/53)
                             v
  Client Mac  -------------> +------------------+
  (Mac 1 or 4)               |  Mac 2 — Edge    |
  dig / curl / browser       |  nginx :443/:80  |
                             |  TLS terminate   |
                             |  load balancer   |
                             +----+--------+----+
                                  |        |
                     HTTP :3001   |        |  HTTP :3002
                                  v        v
                         +--------+--+  +--+--------+
                         | Mac 3     |  | Mac 4     |
                         | Backend A |  | Backend B |
                         | :3001     |  | :3002     |
                         +-----------+  +-----------+
```

**Request path:** Client → DNS (Mac 1) → HTTPS (Mac 2) → Backend A (Mac 3) **or** Backend B (Mac 4)

## 3. Machine / IP / service inventory

Fill in after Task A (LAN setup):

| Role | Hostname | IPv4 | Prefix | Gateway | Interface | MAC | Services |
|------|----------|------|--------|---------|-----------|-----|----------|
| Mac 1 — DNS | | `192.168.x.a` | /24 | | en0 | | dnsmasq |
| Mac 2 — Edge | | `192.168.x.b` | /24 | | en0 | | nginx :443 |
| Mac 3 — Backend A | | `192.168.x.c` | /24 | | en0 | | app :3001 |
| Mac 4 — Backend B | | `192.168.x.d` | /24 | | en0 | | app :3002 |

**DNS records (Phase 1):**

| Name | Type | Value |
|------|------|-------|
| `app.teamX.test` | A | Mac 2 private IP |
| `api.teamX.test` | A | Mac 2 private IP |

## 4. Protocol layers on one request

| Layer (TCP/IP) | What happens | Evidence |
|----------------|--------------|----------|
| Application | DNS query/response; HTTP request/response | dig; curl `-v`; Wireshark DNS |
| Transport | UDP/53 for DNS; TCP three-way handshake; TLS | Wireshark TCP/TLS |
| Network | IPv4 between Macs on private LAN | ping; Wireshark IP |
| Link | Ethernet/Wi-Fi frames on LAN | Wireshark Ethernet |

## 5. Cloud analogues

| Local role | Cloud analogue |
|------------|----------------|
| dnsmasq (Mac 1) | Route 53 / private hosted zone |
| nginx edge (Mac 2) | ALB / CDN edge / reverse proxy |
| Backend A/B | App server ASG instances |

## 6. Phase 2 notes (update after extensions)

- **Backup DNS:** second resolver IP on clients; stop Mac 1 dnsmasq → resolution continues
- **TTL:** short TTL (e.g. 30s); show cache then refresh after change / flush
- **Isolation:** pf/firewall so only Mac 2 reaches `:3001` / `:3002`
- **HA:** nginx `max_fails` / `fail_timeout`; stop A → traffic only to B
- **Edge cutover:** point DNS A record at standby nginx; observe TTL
- **SPOF:** Mac 2 edge remains single point of failure without Active-Active edge

## 7. Diagrams

Place topology / request-flow images in this folder, e.g.:

- `docs/topology.png`
- `docs/request-flow.png`
