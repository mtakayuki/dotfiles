#!/bin/bash
set -euo pipefail

# Setup dotfiles and install tools for the current user.
# Usage: bash install.sh
# Re-running is safe — tools already at the pinned version are skipped.

# Resolve the actual directory where this script lives (follows symlinks).
DOTDIR="$(cd "$(dirname "$(readlink -f "$0")")" && pwd)"
DOTLINK="$HOME/.dotfiles"

# Create ~/.dotfiles symlink if the repo lives elsewhere (e.g. under ghq root).
if [ "$DOTDIR" != "$DOTLINK" ]; then
  if [ -L "$DOTLINK" ]; then
    current_target="$(readlink -f "$DOTLINK")"
    if [ "$current_target" != "$DOTDIR" ]; then
      ln -sfnv "$DOTDIR" "$DOTLINK"
    fi
  elif [ -d "$DOTLINK" ]; then
    echo "ERROR: $DOTLINK is a real directory, not a symlink."
    echo "To migrate, move it to ghq root and re-run:"
    echo "  mv $DOTLINK $DOTDIR"
    echo "  bash $DOTDIR/install.sh"
    exit 1
  else
    ln -sfnv "$DOTDIR" "$DOTLINK"
  fi
fi
LOCAL_BIN="$HOME/.local/bin"
LOCAL_SHARE="$HOME/.local/share"
LOCAL_BASHRC_D="$HOME/.bashrc.d"
mkdir -p "$LOCAL_BIN" "$LOCAL_SHARE" "$LOCAL_BASHRC_D"
chmod 700 "$LOCAL_BASHRC_D"

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
RG_VERSION="15.1.0"
FD_VERSION="10.3.0"
BAT_VERSION="0.26.1"
ZOXIDE_VERSION="0.9.9"
DIRENV_VERSION="2.37.1"

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
  python3 -m zipfile -e "$tmp/ghq.zip" "$tmp"
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

install_rg() {
  if version_contains rg "$RG_VERSION" --version; then
    log "rg $RG_VERSION already installed"
    return
  fi
  log "Installing ripgrep ${RG_VERSION}..."
  local tmp=$(mktemp -d)
  curl -fsSL "https://github.com/BurntSushi/ripgrep/releases/download/${RG_VERSION}/ripgrep-${RG_VERSION}-${ARCH}-unknown-linux-musl.tar.gz" -o "$tmp/rg.tar.gz"
  tar -xzf "$tmp/rg.tar.gz" -C "$tmp"
  install_binary "$tmp/ripgrep-${RG_VERSION}-${ARCH}-unknown-linux-musl/rg" rg
  rm -rf "$tmp"
  log "installed rg $RG_VERSION"
}

install_fd() {
  if version_contains fd "$FD_VERSION" --version; then
    log "fd $FD_VERSION already installed"
    return
  fi
  log "Installing fd ${FD_VERSION}..."
  local tmp=$(mktemp -d)
  curl -fsSL "https://github.com/sharkdp/fd/releases/download/v${FD_VERSION}/fd-v${FD_VERSION}-${ARCH}-unknown-linux-gnu.tar.gz" -o "$tmp/fd.tar.gz"
  tar -xzf "$tmp/fd.tar.gz" -C "$tmp"
  install_binary "$tmp/fd-v${FD_VERSION}-${ARCH}-unknown-linux-gnu/fd" fd
  rm -rf "$tmp"
  log "installed fd $FD_VERSION"
}

install_bat() {
  if version_contains bat "$BAT_VERSION" --version; then
    log "bat $BAT_VERSION already installed"
    return
  fi
  log "Installing bat ${BAT_VERSION}..."
  local tmp=$(mktemp -d)
  curl -fsSL "https://github.com/sharkdp/bat/releases/download/v${BAT_VERSION}/bat-v${BAT_VERSION}-${ARCH}-unknown-linux-gnu.tar.gz" -o "$tmp/bat.tar.gz"
  tar -xzf "$tmp/bat.tar.gz" -C "$tmp"
  install_binary "$tmp/bat-v${BAT_VERSION}-${ARCH}-unknown-linux-gnu/bat" bat
  rm -rf "$tmp"
  log "installed bat $BAT_VERSION"
}

install_zoxide() {
  if version_contains zoxide "$ZOXIDE_VERSION" --version; then
    log "zoxide $ZOXIDE_VERSION already installed"
    return
  fi
  log "Installing zoxide ${ZOXIDE_VERSION}..."
  local tmp=$(mktemp -d)
  curl -fsSL "https://github.com/ajeetdsouza/zoxide/releases/download/v${ZOXIDE_VERSION}/zoxide-${ZOXIDE_VERSION}-${ARCH}-unknown-linux-musl.tar.gz" -o "$tmp/zoxide.tar.gz"
  tar -xzf "$tmp/zoxide.tar.gz" -C "$tmp"
  install_binary "$tmp/zoxide" zoxide
  rm -rf "$tmp"
  log "installed zoxide $ZOXIDE_VERSION"
}

install_direnv() {
  if version_contains direnv "$DIRENV_VERSION" version; then
    log "direnv $DIRENV_VERSION already installed"
    return
  fi
  log "Installing direnv ${DIRENV_VERSION}..."
  curl -fsSL "https://github.com/direnv/direnv/releases/download/v${DIRENV_VERSION}/direnv.linux-${ARCH_GO}" -o "$LOCAL_BIN/direnv"
  chmod +x "$LOCAL_BIN/direnv"
  log "installed direnv $DIRENV_VERSION"
}

# --- Git config ---

setup_gitconfig() {
  log "Configuring git..."

  # include shared config (idempotent)
  git config --global include.path "~/.dotfiles/gitconfig.shared"

  # merge.conflictstyle: zdiff3 requires git 2.35+
  local git_version
  git_version=$(git version | awk '{print $3}')
  if printf '%s\n' "2.35" "$git_version" | sort -V | head -n1 | grep -qF "2.35"; then
    git config --global merge.conflictstyle zdiff3
  else
    git config --global merge.conflictstyle diff3
  fi

  # user setup (only when not yet configured)
  if ! git config --global user.name &>/dev/null; then
    read -p "Git user name: " git_name
    git config --global user.name "$git_name"
  fi
  if ! git config --global user.email &>/dev/null; then
    read -p "Git email: " git_email
    git config --global user.email "$git_email"
  fi

  # per-host git identity and credential helper (scan ~/src/<host>/)
  local ghq_root="$HOME/src"
  if [ -d "$ghq_root" ]; then
    # github.com: always use gh credential helper
    git config --global "credential.https://github.com.helper" \
      "!${LOCAL_BIN}/gh auth git-credential"

    for hostdir in "$ghq_root"/*/; do
      [ -d "$hostdir" ] || continue
      local host
      host=$(basename "$hostdir")
      local include_key="includeIf.gitdir:~/src/${host}/.path"
      # skip if already configured
      git config --global --get "$include_key" &>/dev/null && continue
      local host_config="$HOME/.gitconfig-${host}"

      # email
      read -p "Different email for ~/src/${host}/? (blank = use default): " host_email
      if [ -n "$host_email" ]; then
        git config -f "$host_config" user.email "$host_email"
      fi

      # credential helper (github.com is handled above)
      if [ "$host" != "github.com" ] && \
         ! git config --global "credential.https://${host}.helper" &>/dev/null; then
        read -p "Credential helper for ${host}? [gh/glab/none] (default: none): " cred_helper
        case "$cred_helper" in
          gh)   git config --global "credential.https://${host}.helper" \
                  "!${LOCAL_BIN}/gh auth git-credential" ;;
          glab) git config --global "credential.https://${host}.helper" \
                  "!${LOCAL_BIN}/glab auth git-credential" ;;
        esac
      fi

      # ensure file exists and register includeIf
      [ -f "$host_config" ] || touch "$host_config"
      git config --global "$include_key" "$host_config"
      log "configured $host"
    done
  fi

  log "git configured (user: $(git config --global user.name))"
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
  install_rg
  install_fd
  install_bat
  install_zoxide
  install_direnv

  setup_gitconfig

  echo ""
  log "Done!"
}

main "$@"
