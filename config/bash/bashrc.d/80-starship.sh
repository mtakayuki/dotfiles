# starship prompt (load last to override PS1)
if command -v starship &>/dev/null; then
  eval "$(starship init bash)"
fi
