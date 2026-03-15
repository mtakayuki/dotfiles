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
```

## Key features

- **ghq + peco**: `gcd` to jump to any repository
- **tmux**: vi-mode copy with clipboard support (WSL2: `clip.exe`, macOS: `pbcopy`)
- **git helpers**: `git-account`, `git-enable-remote-url`, `git-disable-remote-url`

## Setup

```shell
git clone <this-repo> ~/.dotfiles
cd ~/.dotfiles
make
```

This creates symlinks from `~/.dotfiles/_*` to `~/.*` (e.g. `_bashrc` -> `~/.bashrc`).

## Requirements

The following tools should be installed separately:

- [ghq](https://github.com/x-motemen/ghq)
- [peco](https://github.com/peco/peco)
- [tmux](https://github.com/tmux/tmux)
