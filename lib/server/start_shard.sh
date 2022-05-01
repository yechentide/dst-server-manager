#######################################
# 作用: 开启世界
# 参数:
#   $1: 存档名-世界名
#######################################
function start_shard() {
    declare -r accent_color=36
    if [[ $(is_shard_running $1) == 'yes' ]]; then
        accent_color_print warn $accent_color '世界 ' $1 ' 处于启动状态！'
        return 0
    fi

    declare -r cluster=$(echo $1 | awk -F- '{print $1}')
    declare -r shard=$(echo $1 | awk -F- '{print $2}')
    declare -r time_out=90

    accent_color_print info $accent_color '正在启动世界 ' $1 ' ...'
    color_print info "启动需要时间，请等待$time_out秒"
    color_print info '本脚本启动世界时禁止自动更新mod, 有需要请在Mod管理面板更新'
    color_print info '如果启动失败，可以再尝试一两次'

    # tmux -x- -y-      --->    某些终端里不可用(tmux版本问题?)
    # tmux -c           --->    CentOS里yum下载的版本过低无法使用
    tmux -u new -d -s $1 "cd $DST_ROOT_DIR/bin64; ./dontstarve_dedicated_server_nullrenderer_x64 -skip_update_server_mods -ugc_directory $UGC_DIR -persistent_storage_root $KLEI_ROOT_DIR -conf_dir $WORLDS_DIR_NAME -cluster $cluster -shard $shard"

    declare i
    for i in $(seq 1 $time_out); do
        sleep 1
        if tmux capture-pane -t $1 -p -S - | grep -sq 'Sim paused'; then
            accent_color_print success $accent_color '成功启动世界 ' $1 ' !'
            return 0
        elif tmux capture-pane -t $1 -p -S - | grep -sq 'Your Server Will Not Start'; then
            color_print error '似乎token不行, 错误信息如下:'
            tmux capture-pane -t $1 -p -S - | grep -s 'Your Server Will Not Start' -A 12 | tail -n 11
            break
        fi
    done

    accent_color_print error $accent_color '世界 ' $1 ' 启动失败！'
    color_print tip '请确保先启动主世界(不然副世界会一直尝试连接主世界)'
    color_print -n info '即将进入后台, 请自己查看失败原因(截图或者复制)'; sleep 2
    tmux display -t "$1:^.top" '请自己查看失败原因(截图或者复制)'
    tmux send-keys -t "$1:^.top" ENTER ENTER
    tmux send-keys -t "$1:^.top" '请查看服务器输出的日志, 按需求复制或者截图, 向他人询问解决方法'
    tmux send-keys -t "$1:^.top" '[提示]tmux按键没被修改的话, 按下Ctrl加b, 松开, 再按d退出。'

    tmux a -t $1
    tmux kill-session -t $1
}
