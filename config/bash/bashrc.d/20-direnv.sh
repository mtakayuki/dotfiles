# direnv (per-directory env vars)
if command -v direnv &>/dev/null; then
  eval "$(direnv hook bash)"
fi
