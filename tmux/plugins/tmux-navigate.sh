#!/usr/bin/env bash
# Navigate panes with sticky zoom and no edge wrapping.
direction=$1
zoomed=$(tmux display -p '#{window_zoomed_flag}')

# Temporarily unzoom so pane_at_* reflects real layout
[ "$zoomed" = "1" ] && tmux resize-pane -Z

case "$direction" in
  -L) at_edge=$(tmux display -p '#{pane_at_left}') ;;
  -R) at_edge=$(tmux display -p '#{pane_at_right}') ;;
  -U) at_edge=$(tmux display -p '#{pane_at_top}') ;;
  -D) at_edge=$(tmux display -p '#{pane_at_bottom}') ;;
esac

[ "$at_edge" = "0" ] && tmux select-pane "$direction"

# Re-zoom if we were zoomed (whether we moved or stayed)
[ "$zoomed" = "1" ] && tmux resize-pane -Z

exit 0
