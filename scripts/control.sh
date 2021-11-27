source ~/DSTServerManager/utils/output.sh

# Parameters:
#   $1: worlds derictory   ~/Klei/worlds
# Return:
#   name of a cluster
#   or error code 1
function select_cluster() {
    if [[ ! -e $1 ]]; then mkdir -p $1; fi

    if [[ $(ls $1 | wc -l) == 0 ]]; then
        return 1
    fi

    PS3='请输入数字来选择一个存档> '
    select selected_cluster in $(ls -l $1 | awk '$1 ~ /d/ {print $9 }'); do break; done

    if ls -l $1 | awk '$1 ~ /d/ {print $9 }' | grep "$selected_cluster" > /dev/null 2>&1; then
        echo $selected_cluster
    else
        return 1
    fi
}

# Parameters:
#   $1: $ARCHITECTURE    32 64
#   $2: $DST_ROOT_DIR    ~/Server
#   $3: $KLEI_ROOT_DIR   ~/Klei
#   $4: $WORLDS_DIR      worlds
#   $5: cluster name
#   $6: $SHARD_MAIN      Main
#   $7: $SHARD_CAVE      Cave
function start_server() {
    if [[ $1 == 64 ]]; then
        tmux new -d -s "$5-$6" "cd $2/bin64; ./dontstarve_dedicated_server_nullrenderer_x64 -persistent_storage_root $3 -conf_dir $4 -cluster $5 -shard $6 -console"
        tmux new -d -s "$5-$7" "cd $2/bin64; ./dontstarve_dedicated_server_nullrenderer_x64 -persistent_storage_root $3 -conf_dir $4 -cluster $5 -shard $7 -console"
    else
        tmux new -d -s "$5-$6" "cd $2/bin; ./dontstarve_dedicated_server_nullrenderer -persistent_storage_root $3 -conf_dir $4 -cluster $5 -shard $6 -console"
        tmux new -d -s "$5-$7" "cd $2/bin; ./dontstarve_dedicated_server_nullrenderer -persistent_storage_root $3 -conf_dir $4 -cluster $5 -shard $7 -console"
    fi
    color_print info "正在开启世界$running_cluster... " -n; count_down 5
    color_print info "世界$running_cluster已经开启！"
}

# Parameters:
#   $1: cluster name
#   $2: $SHARD_MAIN      from main_panel.sh
#   $3: $SHARD_CAVE      from main_panel.sh
function stop_server() {
    if [[ ${#1} == 0 ]]; then
        color_print error '没有开启中的世界！'
        continue
    fi

    tmux send-keys -t "$1-$2" C-c
    tmux send-keys -t "$1-$3" C-c

    color_print info "正在关闭世界$running_cluster... " -n; count_down 5
    color_print info "世界$running_cluster已经关闭！"
}

# Parameters:
#   $1: $DST_ROOT_DIR    from main_panel.sh
function update_server() {
    color_print info "开始升级服务端..."
    ~/Steam/steamcmd.sh +login anonymous +force_install_dir $1 +app_update 343050 validate +quit
    color_print info "服务端升级完毕！"
    #crontab -e
    #0 6 * * * sh update.sh   # schedule a task for update the server every day at 6:00 am
}

# Parameters:
#   $1: $ARCHITECTURE    32 64
#   $2: $DST_ROOT_DIR    ~/Server
function update_mods() {
    if [[ $1 == 64 ]]; then
        $2/bin64/dontstarve_dedicated_server_nullrenderer_x64 -only_update_server_mods
    else
        $2/bin/dontstarve_dedicated_server_nullrenderer -only_update_server_mods
    fi
}
