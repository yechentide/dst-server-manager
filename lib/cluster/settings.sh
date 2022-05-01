function update_world_setting() {
    color_print info '修改世界的配置选项...'

    array=($(generate_list_from_dir -s))
    if [[ ${#array[@]} == 0 ]]; then color_print error '未找到存档!'; return; fi
    select_one info '请选择一个世界'

    declare -r shard=$answer
    declare -r shard_path="$KLEI_ROOT_DIR/$WORLDS_DIR/$(echo $shard | sed 's#-#/#g')"
    stop_shard $shard

    remove_klei_from_worldgenoverride $shard_path
    if ! check_shard $shard_path; then
        return 0
    fi

    if cat $shard_path/worldgenoverride.lua | grep -sq 'CAVE'; then
        lua $REPO_ROOT_DIR/scripts/configure_world.lua $REPO_ROOT_DIR 'update' $shard_path 'false'
    else
        lua $REPO_ROOT_DIR/scripts/configure_world.lua $REPO_ROOT_DIR 'update' $shard_path 'true'
    fi
}

function update_ini_setting() {
    color_print info '修改存档的配置选项...'

    array=($(generate_list_from_dir -cs))
    if [[ ${#array[@]} == 0 ]]; then color_print error '未找到存档!'; return; fi
    color_print info '选择"存档名"来修改cluster.ini, 选择"存档名-世界名"来修改server.ini'
    select_one info '请选择一个存档'

    if echo $answer | grep -sqv -; then
        declare -r cluster=$answer
        declare -r cluster_path="$KLEI_ROOT_DIR/$WORLDS_DIR/$cluster"
        stop_shards_of_cluster $cluster

        if ! check_cluster $cluster_path; then
            accent_color_print warn 36 '这个存档 ' $cluster ' 不符合该脚本的标准'
            return 0
        fi

        lua $REPO_ROOT_DIR/scripts/edit_cluster_ini.lua $REPO_ROOT_DIR 'edit' $cluster_path
    else
        declare -r shard=$answer
        declare -r shard_path="$KLEI_ROOT_DIR/$WORLDS_DIR/$(echo $shard | sed 's#-#/#g')"
        stop_shard $shard

        if ! check_shard $shard_path; then
            return 0
        fi

        lua $REPO_ROOT_DIR/scripts/edit_shard_ini.lua $REPO_ROOT_DIR 'edit' $shard_path
    fi
}
