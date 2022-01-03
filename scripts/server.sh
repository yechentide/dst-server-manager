# Parameters:
#   $1: cluster name
#   $2: $shard_???_name      Main/Cave
# Return:
#   running / sleeping
function check_process() {
    if tmux ls 2>&1 | grep $1 | grep $2 > /dev/null 2>&1; then
        echo 'running'
    else
        echo 'sleeping'
    fi
}

# Parameters:
#   $1: $architecture       32 64
#   $2: $dst_root_dir       ~/Server
#   $3: $klei_root_dir      ~/Klei
#   $4: $worlds_dir         worlds
#   $5: cluster name
#   $6: $shard_main_name    Main
#   $7: $shard_cave_name    Cave
function start_server() {
    color_print info "正在开启世界$5..."
    declare -r _main_stats=$(check_process $5 $6)
    declare -r _cave_stats=$(check_process $5 $7)
    if [[ $_main_stats == 'running' && $_cave_stats == 'running' ]]; then
        color_print error "世界$5的地上地下皆已开启！"
        return 0
    fi

    if [[ $1 == 64 ]]; then
        if [[ $_main_stats == 'sleeping' ]]; then
            tmux new -d -s "$5-$6" "cd $2/bin64; ./dontstarve_dedicated_server_nullrenderer_x64 -persistent_storage_root $3 -conf_dir $4 -cluster $5 -shard $6"
        fi
        if [[ $_cave_stats == 'sleeping' ]]; then
            tmux new -d -s "$5-$7" "cd $2/bin64; ./dontstarve_dedicated_server_nullrenderer_x64 -persistent_storage_root $3 -conf_dir $4 -cluster $5 -shard $7"
        fi
    else
        if [[ $_main_stats == 'sleeping' ]]; then
            tmux new -d -s "$5-$6" "cd $2/bin; ./dontstarve_dedicated_server_nullrenderer -persistent_storage_root $3 -conf_dir $4 -cluster $5 -shard $6"
        fi
        if [[ $_cave_stats == 'sleeping' ]]; then
            tmux new -d -s "$5-$7" "cd $2/bin; ./dontstarve_dedicated_server_nullrenderer -persistent_storage_root $3 -conf_dir $4 -cluster $5 -shard $7"
        fi
    fi
    sleep 6
    color_print info "世界$5已经开启！"; sleep 1
}

# Parameters:
#   $1: cluster name
#   $2: $shard_main_name      Main
#   $3: $shard_cave_name      Cave
function stop_server() {
    color_print info "正在关闭世界$1..."
    if [[ $(check_process $1 $2) == 'running' ]]; then
        tmux send-keys -t "$1-$2" C-c
    #else
    #    color_print info "世界$1的$2部分并未开启"
    fi
    if [[ $(check_process $1 $3) == 'running' ]]; then
        tmux send-keys -t "$1-$3" C-c
    #else
    #    color_print info "世界$1的$2部分并未开启"
    fi
    color_print info "世界$1已经关闭！"; sleep 1
}

# Parameters:
#   $1: $architecture       32 64
#   $2: $dst_root_dir       ~/Server
#   $3: $klei_root_dir      ~/Klei
#   $4: $worlds_dir         worlds
#   $5: cluster name
#   $6: $shard_main_name    Main
#   $7: $shard_cave_name    Cave
function restart_server() {
    stop_server $5 $6 $7
    start_server $1 $2 $3 $4 $5 $6 $7
}

# Parameters:
#   $1: $klei_root_dir      ~/Klei
#   $2: $worlds_dir         worlds
#   $3: $shard_main_name    Main
#   $4: $shard_cave_name    Cave
function stop_all_server() {
    if [[ ! -e $1$2 ]]; then
        color_print error '未找到存档文件夹，跳过stop_all_server()'
        return 0
    fi
    if [[ $(ls $1$2 | wc -l) == 0 ]]; then
        color_print error '未找到任何存档，跳过stop_all_server()'
        return 0
    fi

    declare _cluster
    for _cluster in $(ls -l $1$2 | awk '$1 ~ /d/ {print $9}'); do
        stop_server $_cluster $3 $4
    done
    return 0
}

# Parameters:
#   $1: $dst_root_dir       ~/Server
#   $2: $klei_root_dir      ~/Klei
#   $3: $worlds_dir         worlds
#   $4: $shard_main_name    Main
#   $5: $shard_cave_name    Cave
function update_server() {
    color_print info '升级服务端之前，将会关闭所有运行中的世界！'
    PS3="$(color_print info '请输入选项数字> ')"
    declare _selected
    select _selected in 继续 算了; do break; done
    if [[ $_selected == '算了' ]]; then return 0; fi

    stop_all_server $2 $3 $4 $5
    color_print info "开始升级服务端..."
    tmux new -s 'update-dst' "~/Steam/steamcmd.sh +force_install_dir $1 +login anonymous +app_update 343050 validate +quit"
    color_print info "服务端升级完毕！"
    #crontab -e
    #0 6 * * * sh update.sh   # schedule a task for update the server every day at 6:00 am
}

# Parameters:
#   $1: $architecture       32 64
#   $2: $dst_root_dir       ~/Server
#   $3: $klei_root_dir      ~/Klei
#   $4: $worlds_dir         worlds
#   $5: $shard_main_name    Main
#   $6: $shard_cave_name    Cave
function server_panel() {
    echo ''
    color_print 70 '>>>>>> 服务端管理 <<<<<<'
    display_running_clusters

    declare -r -a _action_list=('启动服务端' '关闭服务端' '重启服务端' '更新服务端' '返回')
    PS3="$(color_print info '[退出或中断操作请直接按 Ctrl加C ]')"$'\n''请输入选项数字> '
    declare _selected
    select _selected in ${_action_list[@]}; do break; done
    if [[ ${#_selected} == 0 ]]; then color_print error '输入错误'; return 0; fi
    
    case $_selected in
    '启动服务端')
        declare -r _cluster=$(select_cluster $3/$4)
        if [[ ${#_cluster} == 0 ]]; then color_print error '选择世界时发生错误，请检查输入以及是否有存档'; return 0; fi
        #if [[ $(check_process _cluster $5) == 0 && $(check_process _cluster $6) == 0 ]]; then
        #    color_print info "世界$_cluster已经开启！"
        #fi
        start_server $1 $2 $3 $4 $_cluster $5 $6
        ;;
    '关闭服务端')
        if tmux ls 2>&1 | grep 'no server' > /dev/null 2>&1; then
            color_print error '未发现开启中的世界！' -n; count_down 3 dot
            return 0
        fi
        declare -r -a _running_cluster_list=$(tmux ls | awk -F- '{print $1}' | sort | uniq)
        PS3="$(color_print info '[退出或中断操作请直接按 Ctrl加C ]')"$'\n''请输入要中止的世界的编号> '
        select _selected in ${_running_cluster_list[@]}; do break; done
        if [[ ${#_selected} == 0 ]]; then color_print error '输入错误'; return 0; fi
        stop_server $_selected $5 $6
        ;;
    '重启服务端')
        if tmux ls 2>&1 | grep 'no server' > /dev/null 2>&1; then
            color_print error '未发现开启中的世界！' -n; count_down 3 dot
            return 0
        fi
        declare -r -a _running_cluster_list=$(tmux ls | awk -F- '{print $1}')
        PS3="$(color_print info '[退出或中断操作请直接按 Ctrl加C ]')"$'\n''请输入要重启的世界的编号> '
        select _selected in ${_running_cluster_list[@]}; do break; done
        if [[ ${#_selected} == 0 ]]; then color_print error '输入错误'; return 0; fi
        restart_server $1 $2 $3 $4 $_selected $5 $6
        ;;
    '更新服务端')
        update_server $2 $3 $4 $5 $6
        ;;
    '返回')
        return 0
        ;;
    *)
        color_print error "${_selected}功能暂未写好" -n; count_down 3 dot
        return 0
        ;;
    esac
    color_print info '即将返回主面板 ' -n; count_down 3
}
