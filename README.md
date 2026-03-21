# dotfiles

Bash/tmux/git settings for Linux (WSL2, VM) and macOS.

## Structure

```
_bash_alias    # shell aliases
_bash_profile  # loads .profile
_bashrc        # bash config (prompt, functions, tmux auto-start)
_profile       # PATH settings, sources os.sh
_gitignore     # global gitignore
_tmux.conf     # tmux config (vi keybindings, clipboard)
bin/           # git helper scripts
os.sh          # OS detection helpers (is_mac, is_linux)
install.sh     # setup script (symlinks + tool installation)
```

## Setup

```shell
# First time (ghq is not yet installed)
mkdir -p ~/src/github.com/mtakayuki
git clone https://github.com/mtakayuki/dotfiles.git ~/src/github.com/mtakayuki/dotfiles
bash ~/src/github.com/mtakayuki/dotfiles/install.sh
```

This will:
1. Create `~/.dotfiles` symlink pointing to the repo
2. Create symlinks from `~/.dotfiles/_*` to `~/.*` (e.g. `_bashrc` -> `~/.bashrc`)
3. Install CLI tools (ghq, fzf, uv, starship, delta, rg, fd, bat, etc.) to `~/.local/bin/`

## Key features

- **starship**: modern prompt with git branch, Python venv, and more
- **ghq + fzf**: `gcd` to jump to any repository
- **fzf**: Ctrl-r for history search, `**<Tab>` for path completion
- **uv**: Python version and package management
- **tmux**: vi-mode copy with clipboard support (WSL2: `clip.exe`, macOS: `pbcopy`)
- **tmux layouts**: `tl` to launch predefined layouts from `~/.tmux/layouts/*.sh`
- **git helpers**: `git-disable-remote-url`, `git-enable-remote-url`
