#!/usr/bin/env bash
# tmux status bar style - Solarized Dark
# Run from tmux.conf via: run "~/.dotfiles/tmux-style.sh"

set -eu

main() {
  # Solarized Dark colors
  base03="#002b36"
  base02="#073642"
  base01="#586e75"
  base00="#657b83"
  base0="#839496"
  base1="#93a1a1"
  yellow="#b58900"
  orange="#cb4b16"
  red="#dc322f"
  magenta="#d33682"
  violet="#6c71c4"
  blue="#268bd2"
  cyan="#2aa198"
  green="#859900"

  sep="#[fg=${base01},bg=default,none]▕#[default]"

  # Nerd Font icons
  icon_git=$'\ue0a0'
  icon_folder=$'\uf07b'
  icon_host=$'\uf108'

  # pane border
  tmux set -g pane-border-style "fg=${base02}"
  tmux set -g pane-active-border-style "fg=${base01}"

  # message
  tmux set -g message-style "fg=${blue},bg=${base02}"

  # status bar
  tmux set -g status "on"
  tmux set -g status-position "top"
  tmux set -g status-style "fg=${base0},bg=${base03}"
  tmux set -g status-interval 5

  # left: repo info
  tmux set -g status-left-length 120
  tmux set -g status-left-style "none"

  git_branch="cd #{pane_current_path} && git branch --show-current 2>/dev/null"
  repo_name="cd #{pane_current_path} && basename \$(git rev-parse --show-toplevel 2>/dev/null) 2>/dev/null"
  tmux set -g status-left " #S ${sep} ${icon_folder} #(${repo_name}) ${sep} ${icon_git} #(${git_branch}) ${sep}"

  # right: pane list + hostname
  tmux set -g status-right-length 120
  tmux set -g status-right-style "none"
  tmux set -g status-right "#(tmux-pane-list) ${sep} ${icon_host} #H "

  # window list (right-justified, after left panel)
  tmux set -g status-justify "right"
  tmux setw -g window-status-style "none,fg=${base01}"
  tmux setw -g window-status-current-style "bold,fg=${base1}"
  tmux setw -g window-status-current-format "  #I #W ${sep}"
  tmux setw -g window-status-format "  #I #W ${sep}"
  tmux setw -g window-status-separator ""
  tmux setw -g window-status-activity-style "none,fg=${orange}"
}

main
