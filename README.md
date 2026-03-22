# dotfiles

Bash/tmux/git settings for Linux (WSL2, VM), managed with Nix Home Manager.

## Structure

```
flake.nix          # Nix flake definition (inputs: nixpkgs, home-manager)
home.nix           # Home Manager config (packages, dotfile symlinks, git)
bootstrap.sh       # Initial setup: install Nix + apply home-manager
config/
  bash/            # bashrc, profile, bash_alias, bash_profile
    bashrc.d/      # drop-in scripts (10-fzf, 20-direnv, ..., 90-zoxide)
  nvim/            # neovim config (lazy.nvim)
  tmux.conf        # tmux config (vi keybindings, clipboard)
  claude/          # Claude Code settings template
bin/               # helper scripts (git-setup-user, setup-proxy-ca, etc.)
```

## Setup

```shell
# Clone
mkdir -p ~/src/github.com/mtakayuki
git clone https://github.com/mtakayuki/dotfiles.git ~/src/github.com/mtakayuki/dotfiles

# Bootstrap (installs Nix, enables flakes, runs home-manager switch)
bash ~/src/github.com/mtakayuki/dotfiles/bootstrap.sh
```

This will:
1. Install Nix (single-user, `--no-daemon`)
2. Apply Home Manager config: install packages and create dotfile symlinks
3. Set up git user/credentials interactively
4. Copy Claude Code settings template (if not present)

## Updating

After editing config files:

```shell
home-manager switch --flake .#default --impure
```

## Packages managed by Home Manager

ghq, fzf, gh, glab, delta, ripgrep, fd, bat, zoxide, direnv, neovim, starship, uv

## Key features

- **starship**: modern prompt with git branch, Python venv, and more
- **ghq + fzf**: `gcd` to jump to any repository
- **fzf**: Ctrl-r for history search, `**<Tab>` for path completion
- **uv**: Python version and package management
- **tmux**: vi-mode copy with clipboard support (WSL2: `clip.exe`)
- **tmux layouts**: `tl` to launch predefined layouts from `~/.tmux/layouts/*.sh`
- **git helpers**: `git-setup-user`, `git-disable-remote-url`, `git-enable-remote-url`
