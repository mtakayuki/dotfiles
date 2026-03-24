# dev: start a Claude Code development session in the current repository
#
# Creates (or switches to) a tmux session with an IDE-like 4-pane layout:
#   +----+------------------------+--------------+
#   |    |                        |              |
#   |yazi|  nvim --listen         |  Claude      |
#   | 5% |  60%                   |  35%         |
#   |    |                        |              |
#   |    +------------------------+              |
#   |    |  terminal (25%)        |              |
#   |    |                        |              |
#   +----+------------------------+--------------+
#
# Files selected in yazi (Enter key) open in the nvim pane.
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
  local sock="/tmp/nvim-${session_name}.sock"

  # Create session with current terminal size so percentage splits work correctly
  tmux new-session -d -s "$session_name" -c "$dir" -x "$(tput cols)" -y "$(tput lines)"

  # Split right for nvim+terminal+claude area (95% of width)
  tmux split-window -h -l 95% -t "=$session_name:1.1" -c "$dir"

  # Split right again for Claude (35% of remaining ≈ 35% total)
  tmux split-window -h -l 37% -t "=$session_name:1.2" -c "$dir"

  # Split nvim pane vertically for terminal (bottom 25%)
  tmux split-window -v -l 25% -t "=$session_name:1.2" -c "$dir"

  # Pane layout:
  #   1.1 = yazi (left)
  #   1.2 = nvim (center-top)
  #   1.3 = terminal (center-bottom)
  #   1.4 = claude (right)

  # Clean up stale socket from previous session
  rm -f "$sock"

  # Start nvim with --listen for remote file opening
  tmux send-keys -t "=$session_name:1.2" "nvim --listen ${sock}" C-m

  # Start yazi with EDITOR set to open files in the nvim server pane
  tmux send-keys -t "=$session_name:1.1" "EDITOR=nvim-remote NVIM_SOCK=${sock} yazi" C-m

  # Start claude in the right pane
  tmux send-keys -t "=$session_name:1.4" 'claude' C-m

  # Focus on the Claude Code pane
  tmux select-pane -t "=$session_name:1.4"
}
