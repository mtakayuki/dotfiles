#!/bin/bash
set -euo pipefail

# Bootstrap script: install Nix (if needed) and apply Home Manager config.
# Usage: bash bootstrap.sh
# Re-running is safe — Nix install is skipped if already present.

DOTDIR="$(cd "$(dirname "$(readlink -f "$0")")" && pwd)"

log() { echo "[bootstrap] $*"; }

# --- Step 1: Install Nix (single-user, no daemon) ---

if command -v nix &>/dev/null; then
  log "Nix already installed ($(nix --version))"
else
  log "Installing Nix (single-user)..."
  sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install) --no-daemon
  log "Nix installed"
fi

# Source Nix profile so nix commands are available in this session
if [ -e "$HOME/.nix-profile/etc/profile.d/nix.sh" ]; then
  . "$HOME/.nix-profile/etc/profile.d/nix.sh"
fi

# --- Step 2: Enable flakes ---

NIX_CONF="$HOME/.config/nix/nix.conf"
if ! grep -qF 'experimental-features' "$NIX_CONF" 2>/dev/null; then
  log "Enabling flakes and nix-command..."
  mkdir -p "$(dirname "$NIX_CONF")"
  echo "experimental-features = nix-command flakes" >> "$NIX_CONF"
fi

# --- Step 3: Apply Home Manager configuration ---

log "Running home-manager switch..."
nix run home-manager -- switch --flake "${DOTDIR}#default" -b backup --impure

# --- Step 4: Git user setup ---

log "Setting up git user..."
"${HOME}/.local/bin/git-setup-user"

# --- Step 5: Claude Code settings ---

CLAUDE_SETTINGS="$HOME/.claude/settings.json"
if [ ! -f "$CLAUDE_SETTINGS" ]; then
  mkdir -p "$HOME/.claude"
  cp "${DOTDIR}/config/claude/settings.template.json" "$CLAUDE_SETTINGS"
  log "Created $CLAUDE_SETTINGS from template"
else
  log "Claude settings already exist (not overwriting)"
fi

log "Done! Restart your shell or run: source ~/.profile"
