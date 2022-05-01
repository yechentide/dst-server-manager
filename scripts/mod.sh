
##############################################################################################





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
    if [[ $1 == 'update' ]] && ! cat ${mod_file_list[0]} | grep -sq "\[\"workshop-"; then
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

function delete_mods() {
    #    从dedicated_server_mods_setup.lua删除这个mod
    array=($(generate_mod_id_list_from_setting_file))
    color_print info '以下是已经下载的模组:'
    declare id=''
    for id in ${array[@]}; do
        echo -n "ID: $id      "
        get_mod_name_from_modinfo "$REPO_ROOT_DIR/.cache/modinfo/$id.lua"
    done

    multi_select info '请选择要删除的模组ID'
    declare -a delete_mods_list=(${array[@]})
    declare -r file_path="$V1_MOD_DIR/dedicated_server_mods_setup.lua"
    declare target_mod_id=''
    for target_mod_id in ${delete_mods_list[@]}; do
        sed -i "/^ServerModSetup(\"$target_mod_id\")/d" $file_path
    done

    # 删除mod文件夹, 并重新复制modinfo.lua
    synchronize_modinfo

    #    从所有存档里删除这个mod
    array=()
    array=$(generate_list_from_dir -c)
    if [[ ${#array} == 0 ]]; then return; fi

    declare -r tmp_path="$REPO_ROOT_DIR/.cache/modoverrides.lua"
    declare cluster
    declare path
    for cluster in ${array[@]}; do
        declare -a mod_file_list=($(find $KLEI_ROOT_DIR/$WORLDS_DIR/$cluster -type f -name modoverrides.lua))
        if [[ ${#mod_file_list[@]} == 0 ]]; then continue; fi                       # 存档里没有mod配置文件的话跳过
        if ! cat ${mod_file_list[0]} | grep -sq "\[\"workshop-"; then continue; fi  # mod配置文件里没有配置的话跳过

        cp ${mod_file_list[0]} $tmp_path
        lua $REPO_ROOT_DIR/scripts/mod_manager.lua $REPO_ROOT_DIR delete "${delete_mods_list[@]}"
        for path in ${mod_file_list[@]}; do
            cp $tmp_path $path
        done
        rm $tmp_path
    done
}

##############################################################################################

function mod_panel() {
    declare -r -a action_list=('下载Mod' '添加Mod' '配置Mod' '更新Mod' '删除Mod' '返回')

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
        '删除Mod')
            delete_mods
            ;;
        '返回')
            color_print info '即将返回主面板'
            sleep 1
            return 0
            ;;
        *)
            color_print -n error "${action}功能暂未写好" ; count_down -d 3
            ;;
        esac
    done
}
