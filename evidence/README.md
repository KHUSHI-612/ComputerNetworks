# Evidence index: Team Newbugs, Phase 1

Screenshots (`.png`, `.jpeg`), Wireshark captures (`.pcapng`) and terminal transcripts (`.txt`).
Transcripts are the exact terminal output copied during the session on 2026-10-02; each file starts with a header saying which Mac it came from.

| Folder | Task | Files |
| --- | --- | --- |
| `A-lan/` | A: LAN | Network details of all 4 Macs (before and after turning off Private Wi-Fi Address), ping from Mac 1 |
| `B-dns/` | B: Private DNS | dnsmasq syntax check and listening sockets, full `dig` screenshot, record/forwarding/NXDOMAIN tests, Mac 1 system resolver, `dig` + `nslookup` from Mac 4, dnsmasq query log |
| `C-backends/` | C: Backends | Edge curl to A and B, local curl and `lsof` showing `*:3001` / `*:3002` |
| `D-loadbal/` | D: Load balancing | A/B alternation, nginx access log, retry/failover log (`up_status=504, 200`) |
| `E-tls/` | E: HTTPS / TLS | Certificate verify, `verify ok` from both clients, TLS bytes rejected by a plain backend |
| `F-caching/` | F: Caching | DevTools disk-cache hit, backend log showing 200 and 304 |
| `G-capture/` | G: Packet capture | Full client capture (`capture1-client-full.pcapng`), DNS on loopback + ARP, TCP + TLS 1.2 request, TLS 1.2 handshake with retransmission, TLS 1.3 handshake, plain HTTP on the edge-to-backend hop, proxy headers |
| `failures/` | Failure demos F1–F5 | Wrong DNS server, wrong DNS record, one backend down (+ nginx log, recovery), both down (502 + nginx log), wrong port (+ Wireshark SYN/RST and capture) |

Useful Wireshark display filters: `dns.qry.name contains "newbugs"`, `arp`, `tcp.flags.syn == 1`, `tls.handshake`, `http`, `tcp.port == 9443`.
