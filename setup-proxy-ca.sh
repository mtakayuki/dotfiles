#!/bin/bash
set -euo pipefail

# Extract and install a proxy CA certificate for environments behind
# a Secure Web Gateway (SSL inspection proxy).
# Run this manually when curl fails with "self-signed certificate in certificate chain".

CERT_DIR="/usr/local/share/ca-certificates"
# Hosts that corporate proxies typically inspect (not on bypass lists)
TEST_HOSTS="astral.sh starship.rs pypi.org"

log() { echo "[proxy-ca] $*"; }

# Find a host that fails SSL (i.e. being intercepted by proxy)
INTERCEPT_HOST=""
for host in $TEST_HOSTS; do
  if ! curl -fsSL --max-time 5 "https://$host" -o /dev/null 2>/dev/null; then
    INTERCEPT_HOST="$host"
    break
  fi
done

if [ -z "$INTERCEPT_HOST" ]; then
  log "SSL works for all test hosts. No proxy CA setup needed."
  exit 0
fi

log "SSL intercepted on $INTERCEPT_HOST — extracting proxy CA..."

tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

# Extract all certificates in the chain (proxy may use intermediate CAs)
if ! openssl s_client -connect "$INTERCEPT_HOST:443" -showcerts </dev/null 2>/dev/null \
     > "$tmp/raw.txt"; then
  log "ERROR: Failed to connect. Check network connectivity."
  exit 1
fi

# Split chain into individual certs
awk '/BEGIN CERTIFICATE/,/END CERTIFICATE/{ print }' "$tmp/raw.txt" \
  | csplit -z -f "$tmp/cert-" -b '%02d.pem' - '/BEGIN CERTIFICATE/' '{*}' 2>/dev/null

cert_count=0
for cert in "$tmp"/cert-*.pem; do
  [ -s "$cert" ] || continue
  subject=$(openssl x509 -in "$cert" -noout -subject 2>/dev/null) || continue
  issuer=$(openssl x509 -in "$cert" -noout -issuer 2>/dev/null) || continue
  log "Found: $subject"
  log "        $issuer"
  dest="$CERT_DIR/proxy-ca-${cert_count}.crt"
  sudo cp "$cert" "$dest"
  cert_count=$((cert_count + 1))
done

if [ "$cert_count" -eq 0 ]; then
  log "ERROR: No certificates extracted."
  exit 1
fi

log "Installed $cert_count certificate(s). Updating CA bundle..."
sudo update-ca-certificates

# Set NODE_EXTRA_CA_CERTS for tools like Claude Code
LOCAL_BASHRC_D="$HOME/.bashrc.d"
CA_BUNDLE="/etc/ssl/certs/ca-certificates.crt"
mkdir -p "$LOCAL_BASHRC_D"
cat > "$LOCAL_BASHRC_D/proxy-ca.sh" <<EOF
export NODE_EXTRA_CA_CERTS="$CA_BUNDLE"
EOF
log "Created $LOCAL_BASHRC_D/proxy-ca.sh (NODE_EXTRA_CA_CERTS=$CA_BUNDLE)"

log "Done. Restart your shell or run: source ~/.profile"
