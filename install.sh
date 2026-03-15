#!/bin/bash
set -euo pipefail

# Install tools to ~/.local for the current user.
# Usage: bash install.sh

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

# ghq
GHQ_VERSION="1.9.4"
echo "Installing ghq ${GHQ_VERSION}..."
curl -fsSL "https://github.com/x-motemen/ghq/releases/download/v${GHQ_VERSION}/ghq_${OS}_${ARCH_GO}.zip" -o /tmp/ghq.zip
unzip -o /tmp/ghq.zip -d /tmp/ghq
install -m 755 /tmp/ghq/ghq_${OS}_${ARCH_GO}/ghq "$LOCAL_BIN/ghq"
rm -rf /tmp/ghq /tmp/ghq.zip

# fzf
FZF_VERSION="0.70.0"
echo "Installing fzf ${FZF_VERSION}..."
curl -fsSL "https://github.com/junegunn/fzf/releases/download/v${FZF_VERSION}/fzf-${FZF_VERSION}-${OS}_${ARCH_GO}.tar.gz" -o /tmp/fzf.tar.gz
tar -xzf /tmp/fzf.tar.gz -C /tmp fzf
install -m 755 /tmp/fzf "$LOCAL_BIN/fzf"
rm -f /tmp/fzf /tmp/fzf.tar.gz

# fzf shell integration (key-bindings, completion)
FZF_SHELL_DIR="$LOCAL_SHARE/fzf/shell"
mkdir -p "$FZF_SHELL_DIR"
curl -fsSL "https://raw.githubusercontent.com/junegunn/fzf/v${FZF_VERSION}/shell/key-bindings.bash" -o "$FZF_SHELL_DIR/key-bindings.bash"
curl -fsSL "https://raw.githubusercontent.com/junegunn/fzf/v${FZF_VERSION}/shell/completion.bash" -o "$FZF_SHELL_DIR/completion.bash"

echo ""
echo "Installed:"
echo "  ghq $(ghq --version 2>/dev/null || echo "${GHQ_VERSION}")"
echo "  fzf $($LOCAL_BIN/fzf --version 2>/dev/null)"
echo ""
echo "All tools installed to $LOCAL_BIN"
