#!/bin/bash
set -euo pipefail

# Install optional/extra tools that not every environment needs.
# Usage: bash install-extras.sh [tool...]
#   bash install-extras.sh az gcloud    # install specific tools
#   bash install-extras.sh              # show available tools

LOCAL_BIN="$HOME/.local/bin"
LOCAL_SHARE="$HOME/.local/share"
export PATH="$LOCAL_BIN:$PATH"

log() { echo "[extras] $*"; }

# --- Azure CLI ---

_is_linux_az() {
  local az_path
  az_path="$(command -v az 2>/dev/null)" || return 1
  # Ignore Windows az on WSL (/mnt/c/...)
  [[ "$az_path" != /mnt/* ]]
}

install_az() {
  if ! _is_linux_az; then
    log "Azure CLI is not installed (Linux)."
    log "Install it with: curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash"
    return 1
  fi

  log "az already installed ($(az version 2>/dev/null | grep azure-cli | head -1))"

  # bastion + ssh extensions
  for ext in bastion ssh; do
    if az extension show --name "$ext" &>/dev/null; then
      log "az extension $ext already installed"
    else
      log "Installing az extension $ext..."
      az extension add --name "$ext" --yes
      log "installed az extension $ext"
    fi
  done
}

# --- Google Cloud SDK ---

install_gcloud() {
  if command -v gcloud &>/dev/null; then
    log "gcloud already installed ($(gcloud version 2>/dev/null | head -1))"
    return
  fi

  log "Installing Google Cloud SDK..."
  local gcloud_dir="$LOCAL_SHARE/google-cloud-sdk"
  local tmp=$(mktemp -d)
  curl -fsSL "https://dl.google.com/dl/cloudsdk/channels/rapid/google-cloud-sdk.tar.gz" -o "$tmp/gcloud.tar.gz"
  tar -xzf "$tmp/gcloud.tar.gz" -C "$tmp"
  rm -rf "$gcloud_dir"
  mv "$tmp/google-cloud-sdk" "$gcloud_dir"
  rm -rf "$tmp"

  # Install without modifying shell profiles
  "$gcloud_dir/install.sh" --quiet --usage-reporting false --path-update false --command-completion false

  # Symlink binaries into ~/.local/bin/
  for bin in gcloud gsutil bq; do
    ln -sfn "$gcloud_dir/bin/$bin" "$LOCAL_BIN/$bin"
  done

  log "installed gcloud to $gcloud_dir"
}

# --- Main ---

available_tools="az gcloud"

show_usage() {
  echo "Usage: bash install-extras.sh [tool...]"
  echo ""
  echo "Available tools:"
  echo "  az      Azure CLI + bastion/ssh extensions"
  echo "  gcloud  Google Cloud SDK"
  echo ""
  echo "Example: bash install-extras.sh az gcloud"
}

if [ $# -eq 0 ]; then
  show_usage
  exit 0
fi

for tool in "$@"; do
  case "$tool" in
    az)     install_az ;;
    gcloud) install_gcloud ;;
    *)
      echo "Unknown tool: $tool"
      show_usage
      exit 1
      ;;
  esac
done

log "Done!"
