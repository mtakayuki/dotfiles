# Dotfiles Repository Guide

## Conventions

### Symlink mapping (`_*` → `~/.*`)

- Files prefixed with `_` are symlinked to `$HOME` with a `.` prefix by `install.sh`.
  - Example: `_bashrc` → `~/.bashrc`, `_tmux.conf` → `~/.tmux.conf`
- **Exception: `_config/`** — must NOT be symlinked as a directory (would overwrite `~/.config`).
  Instead, its children are individually linked into `~/.config/`.
  - Example: `_config/nvim/` → `~/.config/nvim/`

### bashrc.d/ drop-in scripts

- Numbered prefix controls load order: `50-fzf.sh`, `60-ghq.sh`, `90-starship.sh`, etc.
- Two source directories are loaded by `_bashrc`:
  - `~/.dotfiles/bashrc.d/*.sh` — shared (git-managed)
  - `~/.bashrc.d/*.sh` — machine-local (not tracked)
- Scripts can assume `os.sh` (is_mac, is_linux) is already sourced via `_bashrc`.

### Git config split

- `gitconfig.shared` — common settings, loaded via `[include]` in `~/.gitconfig`.
  This file is NOT symlinked; `install.sh` registers it with `git config --global include.path`.
- `~/.gitconfig` — machine-specific settings (user, email, credentials). Not tracked.
- `~/.gitconfig-<host>` — per-host overrides loaded via `includeIf`.

## install.sh design

- **Idempotent**: safe to re-run. Tools already at the pinned version are skipped.
- **No sudo**: everything installs to `~/.local/bin/`.
- **Pinned versions**: each tool has an explicit version variable at the top of the file.
- **Multi-arch**: supports x86_64 and aarch64.

## Review checklist

When modifying this repository, verify:

- [ ] New `_*` files will symlink correctly (no directory overwrite issues).
- [ ] New bashrc.d/ scripts have appropriate number prefix for load order.
- [ ] No secrets committed (AWS keys, tokens, passwords). Secrets belong in `~/.gitconfig`, `~/.bashrc.d/`, or environment variables.
- [ ] Tools added to install.sh follow the existing pattern (version pin, version_contains check, tmpdir download, install_binary).
- [ ] README.md reflects the current tool list and setup instructions.
- [ ] Quoting is correct in shell scripts (glob expansion, paths with spaces).

## Key files

| File | Purpose |
|------|---------|
| `os.sh` | OS detection helpers (`is_mac`, `is_linux`) |
| `install.sh` | Symlinks + tool installation |
| `setup-proxy-ca.sh` | Corporate proxy CA certificate setup (requires sudo) |
| `bin/` | Git helper scripts (added to PATH via `_profile`) |
| `.gitmessage` | Conventional commit template |
