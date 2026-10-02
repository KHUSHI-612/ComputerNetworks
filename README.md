# ComputerNetworks

Private Network Service Platform — Computer Networks course project.

**Core principle:** the application stays simple; the network is the project.

Client resolves `app.teamX.test` via team DNS → HTTPS through nginx edge → load-balanced backends A/B.

## Repo layout

```
docs/       Architecture, topology, IP/service inventory
dns/        dnsmasq configuration
edge/       nginx reverse proxy + TLS notes (never commit CA private keys)
backend/    Minimal REST app (Backend A / B)
scripts/    Start / stop / test / failure helpers
evidence/   Screenshots and Wireshark .pcapng captures
```

## Quick start (fill in your LAN IPs first)

1. Edit placeholders in `dns/dnsmasq.conf`, `edge/team.conf`, and `scripts/env.sh`
2. Mac 1: start DNS — `./scripts/start-dns.sh`
3. Mac 3 / Mac 4: start backends — `./scripts/start-backend.sh A` / `B`
4. Mac 2: issue certs (see `edge/cert-commands.md`), start nginx — `./scripts/start-edge.sh`
5. Point client DNS at Mac 1, then: `./scripts/test-flow.sh`

## Machine roles

| Mac | Role | Services |
|-----|------|----------|
| 1 | Private DNS + test client | dnsmasq |
| 2 | Edge / reverse proxy / LB | nginx + TLS |
| 3 | Backend A | app on `:3001` |
| 4 | Backend B | app on `:3002` |

Replace `teamX` with your team id (e.g. `team1`) everywhere before demo day.
