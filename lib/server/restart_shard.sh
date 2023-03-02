#!/usr/bin/env bash

#######################################
# 作用: 重启世界
# 参数:
#   $1: 存档名-世界名
#######################################
function restart_shard() {
    if [[ $(is_shard_running "$1") == 'yes' ]]; then
        stop_shard "$1"
    fi
    start_shard "$1"
}
