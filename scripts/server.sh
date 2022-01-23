# Parameters:
#   $1: tmux session name    例: c01-Main
#   $2: dst console command
function send_command_to_session() {
    tmux send-keys -t $1 "$2" ENTER
}

# Parameters:
#   $1: tmux session name    例: c01-Main
function shutdown_shard() {
    send_command_to_session $1 'c_shutdown(true)'
}

# Parameters:
#   $1: tmux session name    例: c01-Main
function force_shutdown_session() {
    tmux send-keys -t $1 C-c
}

##############################################################################################

# Parameters:
#   $1: shard name      例: c01-Main
function stop_shard() {
    declare -r _accent_color=36
    if [[ $(is_shard_running $1) == 'no' ]]; then
        accent_color_print warn $_accent_color 'shard ' $1 ' 处于关闭状态！'
        return 0
    fi

    accent_color_print info $_accent_color '正在关闭shard ' $1 ' ...'
    shutdown_shard $1

    declare _i
    for _i in $(seq 1 30); do
        sleep 1
        if [[ $(is_shard_running $1) == 'no' ]]; then
            accent_color_print success $_accent_color '成功关闭shard ' $1 ' !'
            return 0
        fi
    done
    accent_color_print error $_accent_color 'shard ' $1 ' 关闭失败！'
    color_print -n error '请联系作者修bug'; count_down -d 3
    exit 1
}

# Parameters:
#   $1: shard name      例: c01-Main
function start_shard() {
    declare -r _accent_color=36
    if [[ $(is_shard_running $1) == 'yes' ]]; then
        accent_color_print warn $_accent_color 'shard ' $1 ' 处于启动状态！'
        return 0
    fi

    declare -r _cluster=$(echo $1 | awk -F- '{print $1}')
    declare -r _shard=$(echo $1 | awk -F- '{print $2}')

    declare -r _time_out=90
    accent_color_print info $_accent_color '正在启动shard ' $1 ' ...'
    color_print info "启动需要时间，请等待$_time_out秒"
    color_print info '本脚本启动shard时禁止自动更新mod, 请在Mod管理面板更新'
    color_print info '如果启动失败，可以再尝试一两次'
    tmux new -d -s $1 "cd $dst_root_dir/bin64; ./dontstarve_dedicated_server_nullrenderer_x64 -skip_update_server_mods -ugc_directory $mod_dir_v2 -persistent_storage_root $klei_root_dir -conf_dir $worlds_dir -cluster $_cluster -shard $_shard"

    declare _i
    for _i in $(seq 1 $_time_out); do
        sleep 1
        if tmux capture-pane -t $1 -p -S - | grep -sq 'Sim paused'; then
            accent_color_print success $_accent_color '成功启动shard ' $1 ' !'
            return 0
        elif tmux capture-pane -t $1 -p -S - | grep -sq 'Your Server Will Not Start'; then
            color_print error '似乎token不行, 错误信息如下:'
            tmux capture-pane -t $1 -p -S - | grep -s 'Your Server Will Not Start' -A 12 | tail -n 11
            break
        fi
    done
    tmux kill-session -t $1
    accent_color_print error $_accent_color 'shard ' $1 ' 启动失败！'
    color_print tip '请确保先启动主世界'
}

# Parameters:
#   $1: shard name      例: c01-Main
function restart_shard() {
    if [[ $(is_shard_running $1) == 'yes' ]]; then
        stop_shard $1
    fi
    start_shard $1
}

# Parameters:
#   $1: cluster name      例: c01
function stop_shards_of_cluster() {
    declare _shard=''
    for _shard in $(generate_list_from_cluster $1); do
        if [[ $(is_shard_running "$1-$_shard") == 'yes' ]]; then
            stop_shard "$1-$_shard"
        fi
    done
}

function stop_all_shard() {
    declare _shard
    declare -a _shard_list=$(generate_list_from_tmux -s)
    if [[ ${#_shard_list} -gt 0 ]]; then
        for _shard in ${_shard_list[@]}; do
            stop_shard $_shard
        done
    fi
}

function update_server() {
    color_print warn '升级服务端之前，将会关闭所有运行中的shard！'
    yes_or_no warn '是否关闭所有运行中的shard并更新服务端？'
    if [[ $answer == 'no' ]]; then
        color_print -n info '取消升级 '; count_down -d 3
        return 0
    fi

    stop_all_shard
    color_print info "开始升级服务端..."
    color_print -n info '根据网络状况，更新可能会很耗时间，更新完成为止请勿息屏 '; count_down 3
    ~/Steam/steamcmd.sh +force_install_dir $dst_root_dir +login anonymous +app_update 343050 validate +quit

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
    declare -r -a _action_list=('启动服务端' '关闭服务端' '重启服务端' '更新服务端' '返回')

    while true; do
        echo ''
        color_print 70 '>>>>>> 服务端管理 <<<<<<'
        display_running_clusters
        array=()
        answer=''

        color_print info '[退出或中断操作请直接按 Ctrl加C ]'
        array=${_action_list[@]}; select_one info '请从下面选一个'
        declare _action=$answer

        case $_action in
        '启动服务端')
            array=$(generate_list_from_dir -cs)
            if [[ ${#array} == 0 ]]; then color_print error '未找到存档!'; continue; fi

            color_print tip '请确保先启动主世界'
            select_one tip '选择存档名则会启动该存档下的所有shard, 选择shard名则只会启动这个shard'
            # 选择了shard
            if echo $answer | grep -sq -; then
                declare _shard_path="$klei_root_dir/$worlds_dir/$(echo $answer | sed -e "s#-#/#g")"
                if check_shard $_shard_path; then
                    start_shard $answer
                fi
                continue
            fi
            # 选择了cluster
            color_print info "将启动存档 $answer 里所有的世界!"
            declare _shard=''
            if ! check_cluster "$klei_root_dir/$worlds_dir/$answer"; then continue; fi
            for _shard in $(generate_list_from_cluster $answer); do
                declare _shard_path="$klei_root_dir/$worlds_dir/$answer/$_shard"
                if check_shard $_shard_path; then
                    start_shard "$answer-$_shard"
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
            declare _shard=''
            for _shard in $(generate_list_from_cluster $answer); do
                stop_shard "$answer-$_shard"
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
            declare _shard=''
            for _shard in $(generate_list_from_cluster); do
                restart_shard "$answer-$_shard"
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
