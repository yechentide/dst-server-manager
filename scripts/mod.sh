#######################################
# 作用: 确认是不是DST的模组。国内会被墙导致卡住
# 参数:
#   $1: mod id
# 输出:
#   'yes' / 'no'
#######################################
function is_dst_mod() {
    if wget -O - "https://steamcommunity.com/sharedfiles/filedetails/?id=$1" 2>&1 | grep -sq "Don't Starve Together"; then
        echo 'yes'
    else
        echo 'no'
    fi
}

#######################################
# 作用: 让用户输入要下载的模组ID
# 返回:
#   ID的数组   储存在全局变量array
#######################################
function get_mods_id_from_input() {
    declare -a result=()
    color_print info '请输入Mod的ID, 多个ID请用空格隔开'
    while true; do
        read -p '> ' answer
        declare item=''
        for item in ${answer[@]}; do
            if [[ ! $item =~ ^[0-9]+$ ]] || [[ $item -le 0 ]]; then
                color_print warn "请输入正确数字。错误输入将被无视: $item"
                continue
            fi
            result+=($item)
        done
        if [[ ${#result[@]} -gt 0 ]]; then break; fi
    done
    array=(${result[@]})
    #color_print info "输入的ID: ${result[*]}"
}

##############################################################################################

function add_mods_to_setting_file() {
    declare flag=1
    declare -a list=$(generate_mod_id_list_from_setting_file)
    get_mods_id_from_input
    for id in ${array[@]}; do
        if echo "${list[@]}" | grep -sq $id; then
            color_print warn "ID $id 已存在!"
            continue
        fi
        # 国内会被墙...
        #if [[ $(is_dst_mod $id) == 'no' ]]; then
        #    color_print error "ID $id 不是饥荒联机版的Mod"
        #    continue
        #fi
        color_print info "添加Mod: $id"
        echo "ServerModSetup(\"${id}\")" >> "$V1_MOD_DIR/dedicated_server_mods_setup.lua"
        flag=0
    done
    if [[ $flag == 0 ]]; then return 0; else return 1; fi
}

function update_mod() {
    #if ls $UGC_DIR | grep -sq .acf$; then rm $UGC_DIR/*.acf; fi

    declare -r session_name='update_mods'
    tmux new -d -s "$session_name" "cd $DST_ROOT_DIR/bin64; ./dontstarve_dedicated_server_nullrenderer_x64 -only_update_server_mods -ugc_directory $UGC_DIR -persistent_storage_root $REPO_ROOT_DIR/.cache/.klei -conf_dir xxxxxx -cluster tmp -shard master"
    declare -r time_out=360
    color_print info '正在下载/更新Mod...'
    color_print info "一次性指定的Mod越多, 下载越耗时间, 请等待$time_out秒"
    declare i
    for i in $(seq 1 $time_out); do
        sleep 1
        #if tmux capture-pane -t "$session_name" -p -S - | grep -sq 'FinishDownloadingServerMods Complete'; then
        if ! tmux ls 2>&1 | grep -sq $session_name; then
            copy_all_modinfo
            color_print success 'Mod下载/更新完成!'
            return 0
        fi
    done
    #tmux kill-session -t "$session_name"
    color_print error 'Mod下载/更新失败...'
}

function copy_all_modinfo() {
    if ls $REPO_ROOT_DIR/.cache/modinfo | grep -sq '.lua'; then
        rm -rf $REPO_ROOT_DIR/.cache/modinfo/*.lua
    fi
    declare file
    for file in $(find $V1_MOD_DIR $V2_MOD_DIR -maxdepth 3 -type f | grep 'modinfo'); do
        declare id=$(echo $file | awk -F/ '{print $(NF-1)}')
        if echo $id | grep -sq 'workshop'; then
            id=$(echo $id | awk -F- '{print $2}')
        fi
        cp $file "$REPO_ROOT_DIR/.cache/modinfo/$id.lua"
    done
}

function synchronize_modinfo() {
    declare -a list=$(generate_mod_id_list_from_setting_file)
    for file in $(get_mods_from_dir); do
        declare id=$(echo $file | awk -F / '{print $NF}')
        if echo $id | grep -sq 'workshop'; then
            id=$(echo $id | awk -F- '{print $2}')
        fi
        if ! echo "${list[@]}" | grep -sq $id; then
            rm -rf $file
        fi
    done
    copy_all_modinfo
}

##############################################################################################

function download_new_mods() {
    if add_mods_to_setting_file; then
        update_mod
        copy_all_modinfo
        color_print warn '大的Mod可能一次下载不完, 如果添加Mod时没出现的话, 请尝试使用几次更新Mod功能'
    fi
}

# Parameters:
#   $1: 'add' / 'update'
function configure_mods_in_cluster() {
    if ! ls $REPO_ROOT_DIR/.cache/modinfo | grep -sq '.lua'; then color_print warn '未找到任何mod! 请先下载...'; return; fi
    array=$(generate_list_from_dir -c)
    if [[ ${#array} == 0 ]]; then color_print error '未找到存档!'; return; fi

    select_one info '请选择要配置Mod的存档'
    declare -a mod_file_list=($(find $KLEI_ROOT_DIR/$WORLDS_DIR/$answer -type f -name modoverrides.lua))
    if [[ ${#mod_file_list[@]} == 0 ]]; then color_print error '未找到modoverrides.lua!'; return; fi

    declare -r tmp_path="$REPO_ROOT_DIR/.cache/modoverrides.lua"
    if ! cat mod_file_list[0] | grep -sq "[\"workshop-"; then
        color_print warn '请先给该存档添加Mod!'
        return
    fi
    cp ${mod_file_list[0]} $tmp_path
    lua $REPO_ROOT_DIR/scripts/mod_manager.lua $REPO_ROOT_DIR $1

    declare path
    for path in ${mod_file_list[@]}; do
        cp $tmp_path $path
    done
    rm $tmp_path
}

#Mod删除:
#    从所有存档里删除这个mod
#    从dedicated_server_mods_setup.lua删除这个mod
#    从.cache/modinfo删除modinfo文件
#    从ugc_mods删除该mod

##############################################################################################

function mod_panel() {
    declare -r -a action_list=('下载Mod' '添加Mod' '配置Mod' '更新Mod' '返回')
    # 删除Mod

    while true; do
        echo ''
        color_print 70 '>>>>>> Mod管理 <<<<<<'
        display_running_clusters
        array=()
        answer=''

        color_print info '[退出或中断操作请直接按 Ctrl加C ]'
        array=${action_list[@]}; select_one info '请从下面选一个'
        declare action=$answer

        case $action in
        '下载Mod')
            download_new_mods
            ;;
        '添加Mod')
            configure_mods_in_cluster 'add'
            ;;
        '配置Mod')
            configure_mods_in_cluster 'update'
            ;;
        '更新Mod')
            update_mod
            ;;
        '返回')
            color_print -n info '即将返回主面板 '; count_down 3
            return 0
            ;;
        *)
            color_print -n error "${action}功能暂未写好" ; count_down -d 3
            ;;
        esac
    done
}
