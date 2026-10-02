# Shared placeholders — edit before running scripts
export TEAM_ID="teamX"
export DOMAIN="app.${TEAM_ID}.test"
export API_DOMAIN="api.${TEAM_ID}.test"

# Fill with real LAN IPs from Task A
export DNS_IP="192.168.x.a"          # Mac 1
export EDGE_IP="192.168.x.b"         # Mac 2
export BACKEND_A_IP="192.168.x.c"    # Mac 3
export BACKEND_B_IP="192.168.x.d"    # Mac 4

export EDGE_HTTPS_PORT="443"         # or 8443
export BACKEND_A_PORT="3001"
export BACKEND_B_PORT="3002"

# Paths (adjust to your clone location)
export REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
export DNSMASQ_CONF="${REPO_ROOT}/dns/dnsmasq.conf"
export NGINX_CONF="${REPO_ROOT}/edge/team.conf"
