# Parameters:
#   $1: modinfo.lua的路径
# Retuen: 'yes' / 'no'
function is_server_mod() {
    if cat $1 | grep -s 'all_clients_require_mod' | grep -sq 'true' ||
       cat $1 | grep -s 'client_only_mod' | grep -sq 'false'; then
        echo 'yes'
        return 0
    fi
    echo 'no'
}

# Parameters:
#   $1: mod id
# Retuen: 'yes' / 'no'
function is_dst_mod() {
    if wget -O - "https://steamcommunity.com/sharedfiles/filedetails/?id=$1" 2>&1 | grep -sq "Don't Starve Together"; then
        echo 'yes'
    else
        echo 'no'
    fi
}

# Parameters:
#   $1: mod id
# Return: name --> $answer
function get_mod_name_from_web() {
    declare -r _name=$(wget -O - "https://steamcommunity.com/sharedfiles/filedetails/?id=$1" 2>&1 | grep -s workshopItemTitle | sed "s#<div class=\"workshopItemTitle\">\(.*\)</div>#\1#g")
    echo $_name     # 通过echo来去除头尾的空白
}

# Return: 回答 --> $array
function get_mods_id_from_input() {
    declare -a _result=()
    color_print info '请输入Mod的ID, 多个ID请用空格隔开'
    while true; do
        read -p '> ' answer
        declare _item=''
        for _item in ${answer[@]}; do
            if [[ ! $_item =~ ^[0-9]+$ ]] || [[ $_item -le 0 ]]; then
                color_print warn "请输入正确数字。错误输入将被无视: $_item"
                continue
            fi
            _result+=($_item)
        done
        if [[ ${#_result[@]} -gt 0 ]]; then break; fi
    done
    array=(${_result[@]})
    #color_print info "输入的ID: ${_result[*]}"
}

##############################################################################################

function add_mods_to_setting_file() {
    declare _flag=1
    declare -a _list=$(generate_mod_id_list_from_setting_file)
    get_mods_id_from_input
    for _id in ${array[@]}; do
        if echo "${_list[@]}" | grep -sq $_id; then
            color_print warn "ID $_id 已存在!"
            continue
        fi
        if [[ $(is_dst_mod $_id) == 'no' ]]; then
            color_print error "ID $_id 不是饥荒联机版的Mod"
            continue
        fi
        color_print info "添加Mod: $_id"
        echo "ServerModSetup(\"${_id}\")" >> "$mod_dir_v1/dedicated_server_mods_setup.lua"
        _flag=0
    done
    if [[ $_flag == 0 ]]; then return 0; else return 1; fi
}

function update_mod() {
    tmux new -d -s 'update_mods' "cd $dst_root_dir/bin64; ./dontstarve_dedicated_server_nullrenderer_x64 -only_update_server_mods -ugc_directory $ugc_directory -persistent_storage_root $repo_root_dir/.cache/.klei -conf_dir download_mods -cluster tmp -shard master"
    declare -r _time_out=360
    color_print info '正在下载/更新Mod...'
    color_print info '一次性指定的Mod越多, 下载越耗时间'
    color_print info "请等待$_time_out秒"
    declare _i
    for _i in $(seq 1 $_time_out); do
        sleep 1
        if tmux capture-pane -t 'update_mods' -p -S - | grep -sq 'FinishDownloadingServerMods Complete'; then
            color_print success 'Mod下载完成!'
            return 0
        fi
    done
    tmux kill-session -t 'update_mods'
    color_print error 'Mod下载/更新失败...'
}

function copy_all_modinfo() {
    if ls $repo_root_dir/.cache/modinfo | grep -sq '.lua'; then
        rm -rf $repo_root_dir/.cache/modinfo/*.lua
    fi
    declare _file
    for _file in $(find $mod_dir_v1 $mod_dir_v2 -maxdepth 3 -type f | grep 'modinfo'); do
        _id=$(echo $_file | awk -F / '{print $(NF-1)}')
        if echo $_id | grep -sq 'workshop'; then
            _id=$(echo $_id | awk -F- '{print $2}')
        fi
        cp $_file "$repo_root_dir/.cache/modinfo/$_id.lua"
    done
}

function synchronize_modinfo() {
    declare -a _list=$(generate_mod_id_list_from_setting_file)
    for _file in $(get_mods_from_dir); do
        _id=$(echo $_file | awk -F / '{print $NF}')
        if echo $_id | grep -sq 'workshop'; then
            _id=$(echo $_id | awk -F- '{print $2}')
        fi
        if ! echo "${_list[@]}" | grep -sq $_id; then
            rm -rf $_file
        fi
    done
    copy_all_modinfo
}

##############################################################################################

function download_new_mods() {
    if add_mods_to_setting_file; then
        update_mod
        copy_all_modinfo
    fi
}

# Parameters:
#   $1: 'add' / 'update'
function configure_mods_in_cluster() {
    if ! ls $repo_root_dir/.cache/modinfo | grep -sq '.lua'; then color_print warn '未找到任何mod! 请先下载...'; return; fi
    array=$(generate_list_from_dir -c)
    if [[ ${#array} == 0 ]]; then color_print error '未找到存档!'; continue; fi

    select_one info '请选择要配置Mod的存档'
    declare -a mod_file_list=($(find $klei_root_dir/$worlds_dir/$answer -type f -name modoverrides.lua))
    if [[ ${#mod_file_list[@]} == 0 ]]; then color_print error '未找到modoverrides.lua!'; continue; fi

    declare -r _tmp_path="$repo_root_dir/.cache/modoverrides.lua"
    cp ${mod_file_list[0]} $_tmp_path
    lua $repo_root_dir/scripts/mod_manager.lua $repo_root_dir $1

    declare _path
    for _path in ${#mod_file_list[@]}; do
        cp $_tmp_path $_path
    done
    rm $_tmp_path
}

#Mod删除:
#    从所有存档里删除这个mod
#    从dedicated_server_mods_setup.lua删除这个mod
#    从.cache/modinfo删除modinfo文件
#    从ugc_mods删除该mod

##############################################################################################

function mod_panel() {
    declare -r -a _action_list=('下载Mod' '添加Mod' '配置Mod' '更新Mod' '返回')
    # 删除Mod

    while true; do
        echo ''
        color_print 70 '>>>>>> 服务端管理 <<<<<<'
        display_running_clusters

        color_print info '[退出或中断操作请直接按 Ctrl加C ]'
        array=${_action_list[@]}; select_one info '请从下面选一个'
        declare _action=$answer

        case $_action in
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
            color_print -n error "${_action}功能暂未写好" ; count_down -d 3
            ;;
        esac
    done
}
