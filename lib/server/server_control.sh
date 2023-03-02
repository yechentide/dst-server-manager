#!/usr/bin/env bash

#######################################
# 作用: 向session传递命令
# 参数:
#   $1: tmux session名    例: c01-Main
#   $2: dst控制台命令
#######################################
function send_command_to_session() {
    tmux send-keys -t "$1" "$2" ENTER
}

#######################################
# 作用: 关闭指定session里的服务端
# 参数:
#   $1: tmux session名    例: c01-Main
#######################################
function shutdown_shard() {
    send_command_to_session "$1" 'c_shutdown(true)'
}

#######################################
# 作用: 强制关闭指定session里的运行的程序
# 参数:
#   $1: tmux session名    例: c01-Main
#######################################
function force_shutdown_session() {
    tmux send-keys -t "$1" C-c
}

#######################################
# 作用: 检测指定世界是否存在于tmux的session列表里
# 参数:
#   $1: 存档名-世界名
# 输出:
#   'yes' / 'no'
#######################################
function is_shard_running() {
    if tmux ls 2>&1 | grep -sq "$1"; then echo 'yes'; else echo 'no'; fi
}
