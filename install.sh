#!/bin/bash
set -euo pipefail

# Setup dotfiles and install tools for the current user.
# Usage: bash install.sh

DOTDIR="$HOME/.dotfiles"

# --- Symlinks ---
echo "Creating symlinks..."
for file in "$DOTDIR"/_*; do
  name=$(basename "$file")
  ln -sfnv "$file" "$HOME/.${name#_}"
done

# --- Tools ---
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

# uv (Python package manager)
echo "Installing uv..."
UV_UNMANAGED_INSTALL="$LOCAL_BIN" UV_NO_MODIFY_PATH=1 curl -LsSf https://astral.sh/uv/install.sh | sh

# starship (prompt)
echo "Installing starship..."
curl -fsSL https://starship.rs/install.sh -o /tmp/starship-install.sh
sh /tmp/starship-install.sh --yes --bin-dir "$LOCAL_BIN"
rm -f /tmp/starship-install.sh

# gh (GitHub CLI)
GH_VERSION="2.88.1"
echo "Installing gh ${GH_VERSION}..."
curl -fsSL "https://github.com/cli/cli/releases/download/v${GH_VERSION}/gh_${GH_VERSION}_${OS}_${ARCH_GO}.tar.gz" -o /tmp/gh.tar.gz
tar -xzf /tmp/gh.tar.gz -C /tmp
install -m 755 "/tmp/gh_${GH_VERSION}_${OS}_${ARCH_GO}/bin/gh" "$LOCAL_BIN/gh"
rm -rf "/tmp/gh_${GH_VERSION}_${OS}_${ARCH_GO}" /tmp/gh.tar.gz

# glab (GitLab CLI)
GLAB_VERSION="1.89.0"
GLAB_OS=$(uname -s | sed 's/Darwin/darwin/;s/Linux/linux/')
GLAB_ARCH=$(uname -m | sed 's/x86_64/amd64/;s/aarch64/arm64/')
echo "Installing glab ${GLAB_VERSION}..."
curl -fsSL "https://gitlab.com/gitlab-org/cli/-/releases/v${GLAB_VERSION}/downloads/glab_${GLAB_VERSION}_${GLAB_OS}_${GLAB_ARCH}.tar.gz" -o /tmp/glab.tar.gz
tar -xzf /tmp/glab.tar.gz -C /tmp
install -m 755 /tmp/bin/glab "$LOCAL_BIN/glab"
rm -rf /tmp/bin /tmp/glab.tar.gz

echo ""
echo "Done! Installed:"
echo "  ghq $($LOCAL_BIN/ghq --version 2>/dev/null || echo "v${GHQ_VERSION}")"
echo "  fzf $($LOCAL_BIN/fzf --version 2>/dev/null)"
echo "  uv $($LOCAL_BIN/uv --version 2>/dev/null)"
echo "  starship $($LOCAL_BIN/starship --version 2>/dev/null | tail -1)"
echo "  gh $($LOCAL_BIN/gh --version 2>/dev/null | head -1)"
echo "  glab $($LOCAL_BIN/glab --version 2>/dev/null)"
echo "  symlinks -> ~/.*"
