#!/usr/bin/env bash

#######################################
# 参数:
#   $1: 世界名      Cluster-shard
#######################################
function console_manager() {
    declare -r console_pane="$1:^.bottom"
    tmux kill-pane -a -t "$1:^.top"
    tmux split-window -v -l 8 -t "$1"

    tmux select-pane -t "$console_pane"
    tmux send-keys -t "$console_pane" "/$REPO_ROOT_DIR/bin/console $1" ENTER
    tmux a -t "$1"

    tmux send-keys -t "$console_pane" C-c
    tmux kill-pane -t "$console_pane"
}
