# ghq + fzf repository navigation
function gcd {
  local repo="$(ghq list | fzf)"
  if [ -n "$repo" ]; then
    cd "$(ghq root)/$repo"
  fi
}
