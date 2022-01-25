#######################################
# 作用: 向session传递命令
# 参数:
#   $1: tmux session名    例: c01-Main
#   $2: dst控制台命令
#######################################
function send_command_to_session() {
    tmux send-keys -t $1 "$2" ENTER
}

#######################################
# 作用: 关闭指定session里的服务端
# 参数:
#   $1: tmux session名    例: c01-Main
#######################################
function shutdown_shard() {
    send_command_to_session $1 'c_shutdown(true)'
}

#######################################
# 作用: 强制关闭指定session里的运行的程序
# 参数:
#   $1: tmux session名    例: c01-Main
#######################################
function force_shutdown_session() {
    tmux send-keys -t $1 C-c
}

##############################################################################################

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
    color_print -n error '请联系作者修bug'; count_down -d 3
    exit 1
}

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
    tmux new -d -s $1 "cd $DST_ROOT_DIR/bin64; ./dontstarve_dedicated_server_nullrenderer_x64 -skip_update_server_mods -ugc_directory $UGC_DIR -persistent_storage_root $KLEI_ROOT_DIR -conf_dir $WORLDS_DIR -cluster $cluster -shard $shard"

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
    tmux kill-session -t $1
    accent_color_print error $accent_color '世界 ' $1 ' 启动失败！'
    color_print tip '请确保先启动主世界'
}

#######################################
# 作用: 重启世界
# 参数:
#   $1: 存档名-世界名
#######################################
function restart_shard() {
    if [[ $(is_shard_running $1) == 'yes' ]]; then
        stop_shard $1
    fi
    start_shard $1
}

#######################################
# 作用: 关闭指定存档里全部的开启中的世界
# 参数:
#   $1: 存档名
#######################################
function stop_shards_of_cluster() {
    declare shard=''
    for shard in $(generate_list_from_cluster $1); do
        if [[ $(is_shard_running "$1-$shard") == 'yes' ]]; then
            stop_shard "$1-$shard"
        fi
    done
}

function stop_all_shard() {
    declare shard
    declare -a shard_list=$(generate_list_from_tmux -s)
    if [[ ${#shard_list} -gt 0 ]]; then
        for shard in ${shard_list[@]}; do
            stop_shard $shard
        done
    fi
}

function update_server() {
    color_print warn '升级服务端之前，将会关闭所有运行中的世界！'
    yes_or_no warn '是否关闭所有运行中的世界, 并更新服务端？'
    if [[ $answer == 'no' ]]; then
        color_print -n info '取消升级 '; count_down -d 3
        return 0
    fi

    stop_all_shard
    color_print info "开始升级服务端..."
    color_print -n info '根据网络状况，更新可能会很耗时间，更新完成为止请勿息屏 '; count_down 3
    ~/Steam/steamcmd.sh +force_install_dir $DST_ROOT_DIR +login anonymous +app_update 343050 validate +quit

    if [[ $? ]]; then
        color_print success '饥荒服务端更新完成!';
        color_print info '途中可能会出现Failed to init SDL priority manager: SDL not found警告'
        color_print info '不用担心, 这个不影响下载/更新DST'
        color_print -n info '虽然可以解决, 但这需要下载一堆依赖包, 有可能会对其他运行中的服务造成影响, 所以无视它吧～ '; count_down -d 6
    else
        color_print error '似乎出现了什么错误...'
        yes_or_no info '再试一次？'
        if [[ $answer == 'yes' ]]; then
            update_server
        fi
    fi
}

##############################################################################################

function server_panel() {
    declare -r -a action_list=('启动服务端' '关闭服务端' '重启服务端' '更新服务端' '返回')

    while true; do
        echo ''
        color_print 70 '>>>>>> 服务端管理 <<<<<<'
        display_running_clusters
        array=()
        answer=''

        color_print info '[退出或中断操作请直接按 Ctrl加C ]'
        array=${action_list[@]}; select_one info '请从下面选一个'
        declare action=$answer

        case $action in
        '启动服务端')
            array=$(generate_list_from_dir -cs)
            if [[ ${#array} == 0 ]]; then color_print error '未找到存档!'; continue; fi

            color_print tip '请确保先启动主世界'
            select_one tip '选择存档名则会启动该存档下的所有shard, 选择shard名则只会启动这个shard'
            # 选择了shard
            if echo $answer | grep -sq -; then
                declare shard_path="$KLEI_ROOT_DIR/$WORLDS_DIR/$(echo $answer | sed -e "s#-#/#g")"
                if check_shard $shard_path; then
                    start_shard $answer
                fi
                continue
            fi
            # 选择了cluster
            color_print info "将启动存档 $answer 里所有的世界!"
            if ! check_cluster "$KLEI_ROOT_DIR/$WORLDS_DIR/$answer"; then continue; fi
            declare shard=''
            for shard in $(generate_list_from_cluster $answer); do
                declare shard_path="$KLEI_ROOT_DIR/$WORLDS_DIR/$answer/$shard"
                if check_shard $shard_path; then
                    start_shard "$answer-$shard"
                fi
            done
            ;;
        '关闭服务端')
            array=$(generate_list_from_tmux -cs)
            if [[ ${#array} == 0 ]]; then color_print error '没有运行中的shard!'; continue; fi

            select_one tip '选择存档名则会关闭该存档下的所有shard, 选择shard名则只会关闭这个shard'
            # 选择了shard
            if echo $answer | grep -sq -; then
                stop_shard $answer
                continue
            fi
            # 选择了cluster
            declare shard=''
            for shard in $(generate_list_from_cluster $answer); do
                stop_shard "$answer-$shard"
            done
            ;;
        '重启服务端')
            array=$(generate_list_from_tmux -cs)
            if [[ ${#array} == 0 ]]; then color_print error '没有运行中的shard!'; continue; fi

            select_one tip '选择存档名则会重启该存档下的所有shard, 选择shard名则只会重启这个shard'
            # 选择了shard
            if echo $answer | grep -sq -; then
                restart_shard $answer
                continue
            fi
            # 选择了cluster
            declare shard=''
            for shard in $(generate_list_from_cluster $answer); do
                restart_shard "$answer-$shard"
            done
            ;;
        '更新服务端')
            update_server
            ;;
        '返回')
            color_print -n info '即将返回主面板 '; count_down 3
            return 0
            ;;
        *)
            color_print -n error "${_action}功能暂未写好"; count_down -d 3
            ;;
        esac
    done
}
