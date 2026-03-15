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
git clone <this-repo> ~/.dotfiles
cd ~/.dotfiles
bash install.sh
```

This will:
1. Create symlinks from `~/.dotfiles/_*` to `~/.*` (e.g. `_bashrc` -> `~/.bashrc`)
2. Install [ghq](https://github.com/x-motemen/ghq), [fzf](https://github.com/junegunn/fzf), and [uv](https://github.com/astral-sh/uv) to `~/.local/bin/`

## Key features

- **ghq + fzf**: `gcd` to jump to any repository
- **fzf**: Ctrl-r for history search, `**<Tab>` for path completion
- **uv**: Python version and package management
- **tmux**: vi-mode copy with clipboard support (WSL2: `clip.exe`, macOS: `pbcopy`)
- **git helpers**: `git-disable-remote-url`, `git-enable-remote-url`
