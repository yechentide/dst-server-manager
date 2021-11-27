source ~/DSTServerManager/utils/output.sh
source ~/DSTServerManager/scripts/control.sh

# Parameters:
#   $1: $DST_ROOT_DIR      ~/Server
#   $2: worlds derictory   ~/Klei/worlds
#   $3: $SHARD_MAIN        Main
#   $4: $SHARD_CAVE        Cave
#   $5: cluster name       (option parameter)
function add_mods() {
    color_print info '开始添加mod'
    if [[ $# == 5 ]]; then
        target_cluster=$5
    else
        target_cluster=$(select_cluster $2)
    fi
    if [[ ${#target_cluster} == 0 ]]; then
        color_print error '选择世界时发生错误，请检查输入以及是否有存档'
        return 1
    fi

    while true; do
        echo ''
        color_print info '空着或者输入0并按回车结束'
        read -p '请输入mod编号 > ' MOD_ID
        if [[ ${#MOD_ID} == 0 || $MOD_ID == '0' ]]; then break; fi

        if [[ ! "$MOD_ID" =~ ^[0-9]+$ ]]; then
            color_print error "输入错误: $MOD_ID, mod编号必须为数字"
            continue
        fi

        if ! cat $1/mods/dedicated_server_mods_setup.lua | grep $MOD_ID > /dev/null 2>&1; then
            echo "ServerModSetup(\"${MOD_ID}\")" >> $1/mods/dedicated_server_mods_setup.lua
        fi

        if ! cat $2/$target_cluster/$3/modoverrides.lua | grep $MOD_ID > /dev/null 2>&1; then
            sed -i "2i \    [\"workshop-${MOD_ID}\"]={ configuration_options={  }, enabled=true }," $2/$target_cluster/$3/modoverrides.lua
            rm $2/$target_cluster/$4/modoverrides.lua
            cp $2/$target_cluster/$3/modoverrides.lua $2/$target_cluster/$4/modoverrides.lua
        fi
        
        color_print info "成功将mod - ${MOD_ID} 添加到世界$target_cluster"
    done
    color_print info "mod配置文件位置为 $2/$target_cluster/$3/modoverrides.lua $2/$target_cluster/$4/modoverrides.lua"
    color_print info '结束添加mod, 重启服务端来使mod生效'
}

function configure_mods() {
    # todo
    echo 'setup mods'
}
