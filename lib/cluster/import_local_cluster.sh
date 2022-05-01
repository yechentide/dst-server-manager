function import_local_save_data() {
    color_print info "请先把要导入的本地存档, 上传到文件夹: ${IMPORT_DIR}"
    yes_or_no info "是否已经上传到指定文件夹?"
    if [[ $answer == 'no' ]]; then
        color_print info '撤销导入操作'
        return 0
    fi

    if ! array=$(find $IMPORT_DIR -maxdepth 1 -type d | sed -e "s#^$IMPORT_DIR##g" | sed -e "s#^/##g" | grep -v '^\s*$'); then
        color_print warn '指定文件夹里面没有任何文件夹'
        return 0
    fi

    select_one info '请选择要导入的存档'
    declare -r old_cluster_path="$IMPORT_DIR/$answer"

    color_print info '开始导入存档...'
    while true; do
        read_line info '请输入 新的存档文件夹名字 / 要添加世界的存档文件夹名字' tip '(这个名字不是显示在服务器列表的名字)'
        if generate_list_from_dir -c | grep -sq $answer; then
            color_print warn "已有同名存档: $answer"
        else
            break
        fi
    done
    declare -r new_cluster=$answer
    declare -r cluster_path="$KLEI_ROOT_DIR/$WORLDS_DIR/$new_cluster"
    color_print info "存档文件夹名字: $new_cluster"

    # 移动本地存档
    mv $old_cluster_path $cluster_path

    # 输入token
    get_token
    echo $answer > $cluster_path/cluster_token.txt

    # 更新cluster.ini
    mv $cluster_path/cluster.ini $cluster_path/cluster.ini.old
    cp $REPO_ROOT_DIR/templates/cluster/cluster.ini $cluster_path/cluster.ini
    lua $REPO_ROOT_DIR/scripts/edit_cluster_ini.lua $REPO_ROOT_DIR 'convert' $cluster_path/cluster.ini.old $cluster_path/cluster.ini

    # leveldataoverride.lua  --->  worldgenoverride.lua
    if ! array=$(find $cluster_path -maxdepth 1 -type d | sed -e "s#^$cluster_path##g" | sed -e "s#^/##g" | grep -v '^\s*$'); then
        return 0
    fi

    declare shard
    for shard in ${array[@]}; do
        declare is_forest='true'
        declare ini_file="$cluster_path/$shard/server.ini"
        declare old_override_file="$cluster_path/$shard/leveldataoverride.lua"
        # server.ini
        mv $ini_file "${ini_file}.old"
        if cat $old_override_file | grep -sq 'location="forest"'; then
            cp $REPO_ROOT_DIR/templates/shard_forest/server.ini $cluster_path/$shard
        else
            is_forest='false'
            cp $REPO_ROOT_DIR/templates/shard_cave/server.ini $cluster_path/$shard
        fi
        lua $REPO_ROOT_DIR/scripts/edit_shard_ini.lua $REPO_ROOT_DIR 'convert' "${ini_file}.old" $ini_file
        rm "${ini_file}.old"

        # worldgenoverride.lua
        if [[ ! -e $old_override_file ]]; then continue; fi

        declare override_file="$cluster_path/$shard/worldgenoverride.lua"
        mv $old_override_file "${override_file}.old"
        lua $REPO_ROOT_DIR/scripts/configure_world.lua $REPO_ROOT_DIR 'convert' "${override_file}.old" $override_file $is_forest
        rm "${override_file}.old"
    done

    color_print success "存档$new_cluster导入完成～"
}
