#######################################
# 作用: 关闭世界
# 参数:
#   $1: 存档名-世界名
#######################################
function stop_shard() {
    declare -r accent_color=36
    if [[ $(is_shard_running $1) == 'no' ]]; then
        accent_color_print warn $accent_color '世界 ' $1 ' 处于关闭状态！'
        return 0
    fi

    accent_color_print info $accent_color '正在关闭世界 ' $1 ' ...'
    shutdown_shard $1

    declare i
    for i in $(seq 1 30); do
        sleep 1
        if [[ $(is_shard_running $1) == 'no' ]]; then
            accent_color_print success $accent_color '成功关闭世界 ' $1 ' !'
            return 0
        fi
    done
    accent_color_print error $accent_color '世界 ' $1 ' 关闭失败！'
    color_print -n error '6秒后将强制关闭, 中止强制关闭请按Ctrl加c'
    count_down 6
    tmux kill-session -t $1
}

#######################################
# 作用: 关闭指定存档里全部的开启中的世界
# 参数:
#   $1: 存档名
#######################################
function stop_shards_of_cluster() {
    declare shard=''
    for shard in $(generate_list_from_cluster $KLEI_ROOT_DIR $WORLDS_DIR_NAME $1); do
        if [[ $(is_shard_running "$1-$shard") == 'yes' ]]; then
            stop_shard "$1-$shard"
        fi
    done
}

function stop_all_shard() {
    declare shard
    declare -a shard_list=$(generate_server_list -s)
    if [[ ${#shard_list} -gt 0 ]]; then
        for shard in ${shard_list[@]}; do
            stop_shard $shard
        done
    fi
}
