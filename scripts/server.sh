# Parameters:
#   $1: 存档文件夹          ~/Klei/worlds
# Return:
#   提取存档文件夹里的各个cluster里的shard。返回一行字符串。例子: c01-Cave c01-Main c02-Main c03-Cave
function generate_shard_list_from_dir() {
    find $1 -maxdepth 2 -type d | sed -e "s#$1##g" | sed -e "s#^/##g" | grep / | sed -e "s#/#-#g" | sort
}

# Parameters:
#   $1: shard name(在函数内部会更改这个参数原来位置的值), 注意传进来的是变量名(也就是不加$)
#   $2: 存档文件夹          ~/Klei/worlds
function select_shard_from_dir() {
    declare -n _tmp="$1"
    declare -a _shard_list=$(generate_shard_list_from_dir "$2")
    if [[ ${#_shard_list} -gt 0 ]]; then
        select_one _shard_list _tmp
    else
        return 1
    fi
}

# Return:
#   提取存档文件夹里的各个cluster里的shard。返回一行字符串。例子: c01-Cave c01-Main c02-Main c03-Cave
function generate_shard_list_from_tmux() {
    tmux ls 2>&1 | grep -s : | awk '{print $1}' | sed -e "s/://g" | sort
}

# Parameters:
#   $1: shard(在函数内部会更改这个参数原来位置的值), 注意传进来的是变量名(也就是不加$)
function select_shard_from_tmux_list() {
    declare -n _tmp="$1"
    declare -a _shard_list=$(generate_shard_list_from_tmux)
    if [[ ${#_shard_list} -gt 0 ]]; then
        select_one _shard_list _tmp
    else
        return 1
    fi
}

# Parameters:
#   $1: shard name    例: c01-Main
# Return:
#   running / sleeping
function check_process() {
    if tmux ls 2>&1 | grep -sq "$1"; then
        echo 'running'
    else
        echo 'sleeping'
    fi
}

##############################################################################################

# Parameters:
#   $1: shard name    例: c01-Main
function stop_shard() {
    if [[ $(check_process $1) == 'sleeping' ]]; then
        color_print warn 'shard ' -n; color_print 36 $1 -n; color_print 190 ' 已经处于关闭状态！'
        return 0
    fi
    
    color_print info '正在关闭shard ' -n; color_print 36 $1 -n; color_print 33 ' ...'
    tmux send-keys -t $1 C-c

    declare _i
    for _i in $(seq 1 20); do
        sleep 1
        if [[ $(check_process $1) == 'sleeping' ]]; then
            color_print success '成功关闭shard ' -n; color_print 36 $1 -n; color_print 46 ' !'
            return 0
        fi
    done
    color_print error 'shard ' -n; color_print 36 $1 -n; color_print 196 ' 关闭失败！'
    color_print error '请联系作者修bug' -n; count_down 3 dot
    exit 1
}

# Parameters:
#   $1: $architecture       32 64
#   $2: $dst_root_dir       ~/Server
#   $3: $klei_root_dir      ~/Klei
#   $4: $worlds_dir         worlds
#   $5: shard name          例: c01-Main
function start_shard() {
    if [[ $(check_process $5) == 'running' ]]; then
        color_print warn 'shard ' -n; color_print 36 $5 -n; color_print 190 ' 已经处于启动状态！'
        return 0
    fi

    declare _bin_dir
    declare _bin_file
    if [[ $1 == 64 ]]; then _bin_dir='bin64'; else _bin_dir='bin'; fi
    if [[ $1 == 64 ]]; then _bin_file='dontstarve_dedicated_server_nullrenderer_x64'; else _bin_dir='dontstarve_dedicated_server_nullrenderer'; fi
    declare -r _cluster=$(echo $5 | awk -F- '{print $1}')
    declare -r _shard=$(echo $5 | awk -F- '{print $2}')

    declare -r _time_out=60
    color_print info '正在启动shard ' -n; color_print 36 $5 -n; color_print 33 ' ...'
    color_print info "更新mod等都需要时间，请等待$_time_out秒"
    color_print info '如果启动失败，可以再尝试几次'
    tmux new -d -s $5 "cd $2/$_bin_dir; ./$_bin_file -persistent_storage_root $3 -conf_dir $4 -cluster $_cluster -shard $_shard"

    declare _i
    for _i in $(seq 1 $_time_out); do
        sleep 1
        if tmux capture-pane -t $5 -p -S - | grep -sq 'Sim paused'; then
            #color_print warn 'shard' -n; color_print 36 $5 -n; color_print 33 '已经处于启动状态！'
            color_print success '成功启动shard ' -n; color_print 36 $5 -n; color_print 46 ' !'
            return 0
        elif tmux capture-pane -t $5 -p -S - | grep -sq 'Your Server Will Not Start'; then
            color_print error '发生错误, 错误信息如下:'
            tmux capture-pane -t $5 -p -S - | grep -s 'Your Server Will Not Start' -A 12 | tail -n 11
            break
        fi
    done
    tmux kill-session -t $5
    color_print error 'shard ' -n; color_print 36 $5 -n; color_print 196 ' 启动失败！'
}

# Parameters:
#   $1: $architecture       32 64
#   $2: $dst_root_dir       ~/Server
#   $3: $klei_root_dir      ~/Klei
#   $4: $worlds_dir         worlds
#   $5: shard name          例: c01-Main
function restart_shard() {
    if [[ $(check_process $5) == 'running' ]]; then
        stop_shard $5
    fi
    start_shard $1 $2 $3 $4 $5
}

function stop_all_shard() {
    declare _shard
    declare -a _shard_list=$(generate_shard_list_from_tmux)
    if [[ ${#_shard_list} -gt 0 ]]; then
        for _shard in ${_shard_list[@]}; do
            stop_shard $_shard
        done
    fi
}

# Parameters:
#   $1: $dst_root_dir
function update_server() {
    color_print warn '升级服务端之前，将会关闭所有运行中的shard！'
    declare _answer
    yes_or_no _answer warn '是否关闭所有运行中的shard并更新服务端？'
    if [[ $_answer == 'no' ]]; then
        color_print info '取消升级 ' -n; count_down 3 dot
        return 0
    fi

    stop_all_shard
    color_print info "开始升级服务端..."
    color_print info '根据网络状况，更新可能会很耗时间，更新完成为止请勿息屏 ' -n; count_down 3
    ~/Steam/steamcmd.sh +force_install_dir $1 +login anonymous +app_update 343050 validate +quit

    if [[ $? ]]; then
        color_print success '饥荒服务端更新完成!';
        color_print info '途中可能会出现Failed to init SDL priority manager: SDL not found警告'
        color_print info '不用担心, 这个不影响下载/更新DST'
        color_print info '虽然可以解决, 但这需要下载一堆依赖包, 有可能会对其他运行中的服务造成影响, 所以无视它吧～ ' -n; count_down 6 dot
    else
        color_print error '似乎出现了什么错误...'
        declare _try_again
        yes_or_no _tyr_again info '再试一次？'
        if [[ $_tyr_again == 'yes' ]]; then
            update_server $1
        fi
    fi
}

##############################################################################################

# Parameters:
#   $1: $architecture       32 64
#   $2: $dst_root_dir       ~/Server
#   $3: $klei_root_dir      ~/Klei
#   $4: $worlds_dir         worlds
function server_panel() {
    declare _action
    declare -r -a _action_list=('启动服务端' '关闭服务端' '重启服务端' '更新服务端' '返回')

    while true; do
        echo ''
        color_print 70 '>>>>>> 服务端管理 <<<<<<'
        display_running_clusters

        color_print info '[退出或中断操作请直接按 Ctrl加C ]'
        select_one _action_list _action
    
        case $_action in
        '启动服务端')
            declare _shard
            if ! select_shard_from_dir _shard $3/$4; then
                color_print warn '未找到存档！'
                color_print warn '请先新建一个存档！ ' -n; count_down 3 dot
                continue
            fi
            start_shard $1 $2 $3 $4 $_shard
            ;;
        '关闭服务端')
            declare _shard
            if ! select_shard_from_tmux_list _shard; then
                color_print warn '未找到启动中的shard！ ' -n; count_down 3 dot
                continue
            fi
            stop_shard $_shard
            ;;
        '重启服务端')
            declare _shard
            if ! select_shard_from_tmux_list _shard; then
                color_print warn '未找到启动中的shard！ ' -n; count_down 3 dot
                continue
            fi
            restart_shard $1 $2 $3 $4 $_shard
            ;;
        '更新服务端')
            update_server $2
            ;;
        '返回')
            color_print info '即将返回主面板 ' -n; count_down 3
            return 0
            ;;
        *)
            color_print error "${_action}功能暂未写好" -n; count_down 3 dot
            ;;
        esac
    done
}
