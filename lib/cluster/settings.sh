function update_world_setting() {
    color_print info '修改世界的配置选项...'

    array=($(generate_cluster_list -s $KLEI_ROOT_DIR $WORLDS_DIR_NAME))
    if [[ ${#array[@]} == 0 ]]; then color_print error '未找到存档!'; return; fi

    declare shard=''
    rm $ARRAY_PATH
    for shard in ${array[@]}; do echo $shard >> $ARRAY_PATH; done
    selector -cq info '请选择一个世界'
    shard=$(cat $ANSWER_PATH)

    declare -r shard_path="$KLEI_ROOT_DIR/$WORLDS_DIR_NAME/$(echo $shard | sed 's#-#/#g')"
    stop_shard $shard

    remove_klei $shard_path
    if ! check_shard $shard_path; then
        return 0
    fi

    declare file='worldgenoverride.lua'
    if [[ ! -e $shard_path/worldgenoverride.lua ]] && [[ -e $shard_path/leveldataoverride.lua ]]; then
        file='leveldataoverride.lua'
    fi
    if cat $shard_path/$file | grep -sq 'CAVE'; then
        lua $REPO_ROOT_DIR/bin/editor/configure_world.lua $REPO_ROOT_DIR 'update' $shard_path 'false' $file
    else
        lua $REPO_ROOT_DIR/bin/editor/configure_world.lua $REPO_ROOT_DIR 'update' $shard_path 'true' $file
    fi
}

function update_ini_setting() {
    color_print info '修改存档的配置选项...'

    array=($(generate_cluster_list -cs $KLEI_ROOT_DIR $WORLDS_DIR_NAME))
    if [[ ${#array[@]} == 0 ]]; then color_print error '未找到存档!'; return; fi
    color_print info '选择"存档名"来修改cluster.ini, 选择"存档名-世界名"来修改server.ini'

    declare answer=''
    rm $ARRAY_PATH
    for answer in ${array[@]}; do echo $answer >> $ARRAY_PATH; done
    selector -cq info '请选择一个存档'
    answer=$(cat $ANSWER_PATH)

    if echo $answer | grep -sqv -; then
        # cluster.ini
        declare -r cluster=$answer
        declare -r cluster_path="$KLEI_ROOT_DIR/$WORLDS_DIR_NAME/$cluster"
        stop_shards_of_cluster $cluster

        if ! check_cluster $cluster_path; then
            accent_color_print warn 36 '这个存档 ' $cluster ' 不符合该脚本的标准'
            return 0
        fi

        lua $REPO_ROOT_DIR/bin/editor/edit_cluster_ini.lua $REPO_ROOT_DIR 'edit' $cluster_path
    else
        # server.ini
        declare -r shard=$answer
        declare -r shard_path="$KLEI_ROOT_DIR/$WORLDS_DIR_NAME/$(echo $shard | sed 's#-#/#g')"
        stop_shard $shard

        if ! check_shard $shard_path; then
            return 0
        fi

        lua $REPO_ROOT_DIR/bin/editor/edit_shard_ini.lua $REPO_ROOT_DIR 'edit' $shard_path
    fi
}
