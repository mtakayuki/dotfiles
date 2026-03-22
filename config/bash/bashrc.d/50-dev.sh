# dev: start a Claude Code development session in the current repository
#
# Creates (or switches to) a tmux session with a 3-pane layout:
#   +----------+----------+
#   |          |  claude   |
#   |  nvim    +----------+
#   |          | terminal  |
#   +----------+----------+
#
# Usage:
#   dev [directory]   start in the given (or current) directory
#   devi              interactively select a ghq repository with fzf

function dev {
  local dir="${1:-.}"
  dir="$(cd "$dir" && pwd)"

  # Derive session name from directory basename.
  # tmux doesn't allow dots in session names, replace with dashes.
  local session_name
  session_name="$(basename "$dir" | tr '.' '-')"

  # If already inside tmux, switch to existing session or create a new one.
  if [ -n "${TMUX:-}" ]; then
    if tmux has-session -t "=$session_name" 2>/dev/null; then
      tmux switch-client -t "=$session_name"
      return
    fi
    # Create detached, then switch
    _dev_create_session "$session_name" "$dir"
    tmux switch-client -t "=$session_name"
  else
    if tmux has-session -t "=$session_name" 2>/dev/null; then
      tmux attach-session -t "=$session_name"
      return
    fi
    _dev_create_session "$session_name" "$dir"
    tmux attach-session -t "=$session_name"
  fi
}

function devi {
  local repo
  repo="$(ghq list | fzf --prompt='dev> ')"
  [ -n "$repo" ] && dev "$(ghq root)/$repo"
}

function _dev_create_session {
  local session_name="$1"
  local dir="$2"

  # Create session with first pane (will become nvim on the left)
  tmux new-session -d -s "$session_name" -c "$dir"

  # Split right: Claude Code (top-right)
  tmux split-window -h -t "=$session_name:1.1" -c "$dir"

  # Split below the right pane: terminal (bottom-right)
  tmux split-window -v -t "=$session_name:1.2" -c "$dir"

  # Set layout: left pane ~50%, right pane split vertically
  # Select the left pane (nvim) and start nvim
  tmux send-keys -t "=$session_name:1.1" 'nvim' C-m

  # Start claude in the top-right pane
  tmux send-keys -t "=$session_name:1.2" 'claude' C-m

  # Focus on the Claude Code pane (top-right)
  tmux select-pane -t "=$session_name:1.2"
}
