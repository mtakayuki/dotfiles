# gwt: git worktree helpers
#
# Creates worktrees alongside the repository with a --branch naming convention.
#   ~/src/github.com/org/repo/            ← main
#   ~/src/github.com/org/repo--feature-nvim/  ← worktree (branch: feature/nvim)
#
# Usage:
#   gwt <branch>       create a worktree for the given branch
#   gwt -d <branch>    remove a worktree and its tmux session

function gwt {
  if [ "$1" = "-d" ]; then
    shift
    _gwt_remove "$@"
  else
    _gwt_create "$@"
  fi
}

function _gwt_create {
  local branch="$1"
  if [ -z "$branch" ]; then
    echo "Usage: gwt <branch>"
    return 1
  fi

  local repo_root
  repo_root="$(git rev-parse --show-toplevel 2>/dev/null)"
  if [ -z "$repo_root" ]; then
    echo "Not in a git repository"
    return 1
  fi

  local wt_dir="${repo_root}--${branch//\//-}"

  if [ -d "$wt_dir" ]; then
    echo "Worktree already exists: $wt_dir"
    return 1
  fi

  # Create branch if it doesn't exist, otherwise check it out
  if git rev-parse --verify "$branch" &>/dev/null; then
    git worktree add "$wt_dir" "$branch"
  else
    git worktree add -b "$branch" "$wt_dir"
  fi
}

function _gwt_remove {
  local branch="$1"
  if [ -z "$branch" ]; then
    echo "Usage: gwt -d <branch>"
    return 1
  fi

  local repo_root
  repo_root="$(git rev-parse --show-toplevel 2>/dev/null)"
  if [ -z "$repo_root" ]; then
    echo "Not in a git repository"
    return 1
  fi

  local wt_dir="${repo_root}--${branch//\//-}"
  local repo_name
  repo_name="$(basename "$repo_root")"
  local session_name
  session_name="$(echo "${repo_name}--${branch//\//-}" | tr '.' '-')"

  # Kill tmux session if it exists
  if tmux has-session -t "=$session_name" 2>/dev/null; then
    tmux kill-session -t "=$session_name"
    echo "Killed tmux session: $session_name"
  fi

  git worktree remove "$wt_dir"
}
