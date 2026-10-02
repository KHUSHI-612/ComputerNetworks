# TLS certificate commands (Mac 2)

**Never commit private keys or a CA private key to git.** Store keys only under `/usr/local/etc/nginx/certs/` (or `edge/certs/` locally, gitignored).

Replace `teamX` with your team id. Run on Mac 2.

## 1. Create cert directory

```bash
mkdir -p /usr/local/etc/nginx/certs
cd /usr/local/etc/nginx/certs
```

## 2. Self-signed cert covering project names (Phase 1)

```bash
openssl req -x509 -nodes -newkey rsa:2048 -days 365 \
  -keyout teamX.key \
  -out teamX.crt \
  -subj "/CN=app.teamX.test/O=CN-Project-TeamX" \
  -addext "subjectAltName=DNS:app.teamX.test,DNS:api.teamX.test"
```

## 3. Trust the cert on client Macs (macOS)

```bash
# Copy teamX.crt to the client, then:
sudo security add-trusted-cert -d -r trustRoot \
  -k /Library/Keychains/System.keychain teamX.crt
```

Browsers / curl should then accept `https://app.teamX.test` without warnings.

## 4. Verify

```bash
openssl x509 -in teamX.crt -noout -text | grep -A3 'Subject Alternative Name'
curl -vI https://app.teamX.test/
```

## Optional: local team CA (Phase 2 documentation)

If you mint a team CA and sign leaf certs, **do not** put the CA key in this repo. Keep it offline / local only; commit only the public CA cert if needed for client trust notes.
