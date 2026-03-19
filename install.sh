#!/bin/bash
set -euo pipefail

# Setup dotfiles and install tools for the current user.
# Usage: bash install.sh
# Re-running is safe — tools already at the pinned version are skipped.

DOTDIR="$HOME/.dotfiles"
LOCAL_BIN="$HOME/.local/bin"
LOCAL_SHARE="$HOME/.local/share"
mkdir -p "$LOCAL_BIN" "$LOCAL_SHARE"

ARCH=$(uname -m)
case "$ARCH" in
  x86_64)  ARCH_GO="amd64" ;;
  aarch64) ARCH_GO="arm64" ;;
  *) echo "Unsupported architecture: $ARCH"; exit 1 ;;
esac

OS=$(uname -s | tr '[:upper:]' '[:lower:]')

# Pinned versions
GHQ_VERSION="1.9.4"
FZF_VERSION="0.70.0"
GH_VERSION="2.88.1"
GLAB_VERSION="1.89.0"
DELTA_VERSION="0.18.2"

# --- Helpers ---

log() { echo "[install] $*"; }

version_contains() {
  local cmd="$1" expected="$2"
  shift 2
  command -v "$cmd" &>/dev/null || return 1
  "$cmd" "$@" 2>/dev/null | head -n1 | grep -qF "$expected"
}

install_binary() {
  install -m 755 "$1" "$LOCAL_BIN/$2"
}

# --- Symlinks ---

install_symlinks() {
  log "Creating symlinks..."
  for file in "$DOTDIR"/_*; do
    name=$(basename "$file")
    ln -sfnv "$file" "$HOME/.${name#_}"
  done
}

# --- Tools ---

install_ghq() {
  if version_contains ghq "$GHQ_VERSION" --version; then
    log "ghq $GHQ_VERSION already installed"
    return
  fi
  log "Installing ghq ${GHQ_VERSION}..."
  local tmp=$(mktemp -d)
  curl -fsSL "https://github.com/x-motemen/ghq/releases/download/v${GHQ_VERSION}/ghq_${OS}_${ARCH_GO}.zip" -o "$tmp/ghq.zip"
  unzip -o "$tmp/ghq.zip" -d "$tmp"
  install_binary "$tmp/ghq_${OS}_${ARCH_GO}/ghq" ghq
  rm -rf "$tmp"
  log "installed ghq $GHQ_VERSION"
}

install_fzf() {
  if version_contains fzf "$FZF_VERSION" --version; then
    log "fzf $FZF_VERSION already installed"
    return
  fi
  log "Installing fzf ${FZF_VERSION}..."
  local tmp=$(mktemp -d)
  curl -fsSL "https://github.com/junegunn/fzf/releases/download/v${FZF_VERSION}/fzf-${FZF_VERSION}-${OS}_${ARCH_GO}.tar.gz" -o "$tmp/fzf.tar.gz"
  tar -xzf "$tmp/fzf.tar.gz" -C "$tmp" fzf
  install_binary "$tmp/fzf" fzf
  rm -rf "$tmp"

  # shell integration (key-bindings, completion)
  local shell_dir="$LOCAL_SHARE/fzf/shell"
  mkdir -p "$shell_dir"
  curl -fsSL "https://raw.githubusercontent.com/junegunn/fzf/v${FZF_VERSION}/shell/key-bindings.bash" -o "$shell_dir/key-bindings.bash"
  curl -fsSL "https://raw.githubusercontent.com/junegunn/fzf/v${FZF_VERSION}/shell/completion.bash" -o "$shell_dir/completion.bash"
  log "installed fzf $FZF_VERSION"
}

install_uv() {
  if command -v uv &>/dev/null; then
    log "uv $(uv --version 2>/dev/null) already installed"
    return
  fi
  log "Installing uv..."
  UV_UNMANAGED_INSTALL="$LOCAL_BIN" UV_NO_MODIFY_PATH=1 curl -LsSf https://astral.sh/uv/install.sh | sh
  log "installed uv"
}

install_starship() {
  if command -v starship &>/dev/null; then
    log "starship $(starship --version 2>/dev/null | tail -1) already installed"
    return
  fi
  log "Installing starship..."
  local tmp=$(mktemp -d)
  curl -fsSL https://starship.rs/install.sh -o "$tmp/starship-install.sh"
  sh "$tmp/starship-install.sh" --yes --bin-dir "$LOCAL_BIN"
  rm -rf "$tmp"
  log "installed starship"
}

install_gh() {
  if version_contains gh "$GH_VERSION" --version; then
    log "gh $GH_VERSION already installed"
    return
  fi
  log "Installing gh ${GH_VERSION}..."
  local tmp=$(mktemp -d)
  curl -fsSL "https://github.com/cli/cli/releases/download/v${GH_VERSION}/gh_${GH_VERSION}_${OS}_${ARCH_GO}.tar.gz" -o "$tmp/gh.tar.gz"
  tar -xzf "$tmp/gh.tar.gz" -C "$tmp"
  install_binary "$tmp/gh_${GH_VERSION}_${OS}_${ARCH_GO}/bin/gh" gh
  rm -rf "$tmp"
  log "installed gh $GH_VERSION"
}

install_delta() {
  if version_contains delta "$DELTA_VERSION" --version; then
    log "delta $DELTA_VERSION already installed"
    return
  fi
  log "Installing delta ${DELTA_VERSION}..."
  local tmp=$(mktemp -d)
  local arch_gnu=$(uname -m)
  curl -fsSL "https://github.com/dandavison/delta/releases/download/${DELTA_VERSION}/delta-${DELTA_VERSION}-${arch_gnu}-unknown-linux-gnu.tar.gz" -o "$tmp/delta.tar.gz"
  tar -xzf "$tmp/delta.tar.gz" -C "$tmp"
  install_binary "$tmp/delta-${DELTA_VERSION}-${arch_gnu}-unknown-linux-gnu/delta" delta
  rm -rf "$tmp"
  log "installed delta $DELTA_VERSION"
}

install_glab() {
  if version_contains glab "$GLAB_VERSION" version; then
    log "glab $GLAB_VERSION already installed"
    return
  fi
  log "Installing glab ${GLAB_VERSION}..."
  local glab_os=$(uname -s | sed 's/Darwin/darwin/;s/Linux/linux/')
  local glab_arch=$(uname -m | sed 's/x86_64/amd64/;s/aarch64/arm64/')
  local tmp=$(mktemp -d)
  curl -fsSL "https://gitlab.com/gitlab-org/cli/-/releases/v${GLAB_VERSION}/downloads/glab_${GLAB_VERSION}_${glab_os}_${glab_arch}.tar.gz" -o "$tmp/glab.tar.gz"
  tar -xzf "$tmp/glab.tar.gz" -C "$tmp"
  install_binary "$tmp/bin/glab" glab
  rm -rf "$tmp"
  log "installed glab $GLAB_VERSION"
}

# --- Main ---

main() {
  install_symlinks

  log "Installing pinned toolchain into $LOCAL_BIN"
  install_ghq
  install_fzf
  install_uv
  install_starship
  install_delta
  install_gh
  install_glab

  echo ""
  log "Done!"
}

main "$@"
