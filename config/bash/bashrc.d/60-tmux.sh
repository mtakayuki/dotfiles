# tmux layout launcher
function tl {
  local layout_dir="$HOME/.tmux/layouts"
  if [ ! -d "$layout_dir" ] || [ -z "$(ls "$layout_dir"/*.sh 2>/dev/null)" ]; then
    echo "No layouts found in $layout_dir"
    echo "Create a layout: $layout_dir/<name>.sh"
    return 1
  fi

  local file
  if [ -n "$1" ]; then
    file="$layout_dir/$1.sh"
  else
    file="$(ls "$layout_dir"/*.sh | xargs -n1 basename | sed 's/\.sh$//' | fzf --prompt='layout> ')"
    [ -n "$file" ] && file="$layout_dir/$file.sh"
  fi

  if [ -f "$file" ]; then
    bash "$file"
  else
    echo "Layout not found: $file"
    return 1
  fi
}

# tmux auto-attach (only in interactive terminal)
if [ -z "$TMUX" ] && [ -t 0 ]; then
  if tmux has-session -t main 2>/dev/null; then
    tmux attach -t main
  else
    tmux new-session -s main
  fi
fi
