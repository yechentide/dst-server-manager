#######################################
# 作用: 删除指定存档
# 参数:
#   $1: 存档名
#######################################
function delete_cluster() {
    declare -r accent_color=36
    # stop shard
    stop_shards_of_cluster $1

    confirm warn "确定要删除存档$1?"
    if [[ $(cat $ANSWER_PATH) == 'no' ]]; then
        color_print info '取消删除 '
        sleep 1
        return 0
    fi

    if [[ ! -e /tmp/deleted_cluster ]]; then mkdir -p /tmp/deleted_cluster; fi
    declare -r new_path="/tmp/deleted_cluster/$1-$(date '+%Y%m%d-%H%M%S')"
    mv $KLEI_ROOT_DIR/$WORLDS_DIR_NAME/$1 $new_path > /dev/null 2>&1

    if [[ $? ]]; then
        accent_color_print -p 2 success $accent_color '存档 ' $1 ' 已经移动到 ' $new_path '，主机关机时会自动删除!'
        color_print info '要是后悔了，主机关机之前还来得及哦～ ' -n; count_down 3
    else
        color_print error '似乎出现了什么错误...'
    fi
}
