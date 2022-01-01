# Parameters:
#   $1: $repo_root_dir     ~/DSTServerManager
#   $2: $dst_root_dir      ~/Server
#   $3: worlds derictory   ~/Klei/worlds
#   $4: $SHARD_MAIN        Main
#   $5: $SHARD_CAVE        Cave
#   $6: cluster name       (option parameter)
function add_mods() {
    color_print info '开始添加mod'
    declare _target_cluster
    if [[ $# == 6 ]]; then
        _target_cluster=$6
    else
        _target_cluster=$(select_cluster $3)
    fi
    if [[ ${#_target_cluster} == 0 ]]; then
        color_print error '选择世界时发生错误，请检查输入以及是否有存档'
        return 0
    fi

    if [[ ! -e $3/$_target_cluster/$4/modoverrides.lua ]]; then cp $1/templates/modoverrides.lua $3/$_target_cluster/$4; fi

    declare _mod_id
    while true; do
        echo ''
        color_print info '空着或者输入0并按回车结束'
        read -p '请输入mod编号 > ' _mod_id
        if [[ ${#_mod_id} == 0 || $_mod_id == '0' ]]; then break; fi

        if [[ ! "$_mod_id" =~ ^[0-9]+$ ]]; then
            color_print error "输入错误: $_mod_id, mod编号必须为数字"
            continue
        fi

        if ! cat $2/mods/dedicated_server_mods_setup.lua | grep $_mod_id > /dev/null 2>&1; then
            echo "ServerModSetup(\"${_mod_id}\")" >> $2/mods/dedicated_server_mods_setup.lua
        fi

        if ! cat $3/$_target_cluster/$4/modoverrides.lua | grep $_mod_id > /dev/null 2>&1; then
            sed -i "2i \    [\"workshop-${_mod_id}\"]={ configuration_options={  }, enabled=true }," $3/$_target_cluster/$4/modoverrides.lua
            cp $3/$_target_cluster/$4/modoverrides.lua $3/$_target_cluster/$5/modoverrides.lua
        fi
        
        color_print info "成功将mod - ${_mod_id} 添加到世界$_target_cluster"
    done
    color_print info "mod配置文件位置为 $3/$_target_cluster/$4/modoverrides.lua $3/$_target_cluster/$5/modoverrides.lua"
    color_print info '结束添加mod, 重启服务端来使mod生效'
}

# Parameters:
#   $1: $architecture    32 64
#   $2: $dst_root_dir    ~/Server
function update_mods() {
    if [[ $1 == 64 ]]; then
        $2/bin64/dontstarve_dedicated_server_nullrenderer_x64 -only_update_server_mods
    else
        $2/bin/dontstarve_dedicated_server_nullrenderer -only_update_server_mods
    fi
}

# Parameters:
#   $1: $architecture      32 64
#   $2: $repo_root_dir     ~/DSTServerManager
#   $3: $dst_root_dir      ~/Server
#   $4: worlds derictory   ~/Klei/worlds
#   $5: $SHARD_MAIN        Main
#   $6: $SHARD_CAVE        Cave
function mod_panel() {
    echo ''
    color_print 70 '>>>>>> Mod管理 <<<<<<'
    display_running_clusters

    declare -r -a _action_list=('添加Mod' '配置Mod' '更新Mod' '删除Mod' '返回')
    PS3="$(color_print info '[退出或中断操作请直接按 Ctrl加C ]')"$'\n''请输入选项数字> '
    declare _selected
    select _selected in ${_action_list[@]}; do break; done
    if [[ ${#_selected} == 0 ]]; then color_print error '输入错误'; return 0; fi
    
    case $_selected in
    '添加Mod')
        add_mods $2 $3 $4 $5 $6
        ;;
    #'配置Mod')
    #    ;;
    '更新Mod')
        update_mods $1 $3
        ;;
    #'删除Mod')
    #    ;;
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
