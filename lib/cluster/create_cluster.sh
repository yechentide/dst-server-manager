function create_cluster() {
    color_print info '开始创建新的存档...'
    
    color_print -n 30 '已有存档: '; generate_cluster_list -c $KLEI_ROOT_DIR $WORLDS_DIR_NAME | tr '\n' ' '; echo ''
    read_line info '请输入 新的存档文件夹名字 / 要添加世界的存档文件夹名字' tip '(这个名字不是显示在服务器列表的名字)'
    declare -r new_cluster=$(cat $ANSWER_PATH)
    declare -r cluster_path="$KLEI_ROOT_DIR/$WORLDS_DIR_NAME/$new_cluster"

    if generate_cluster_list -c $KLEI_ROOT_DIR $WORLDS_DIR_NAME | grep -sq $new_cluster; then
        color_print warn "已有同名存档: $new_cluster"
        add_shard_to_cluster $cluster_path $new_cluster
        return 0
    fi
    color_print info "存档文件夹名字: $new_cluster"

    # 复制cluster模板过去
    cp -r $REPO_ROOT_DIR/templates/cluster $cluster_path

    # 输入token
    get_token
    cat $ANSWER_PATH > $cluster_path/cluster_token.txt

    # 编辑cluster.ini
    lua $REPO_ROOT_DIR/bin/editor/edit_cluster_ini.lua $REPO_ROOT_DIR 'edit' "$KLEI_ROOT_DIR/$WORLDS_DIR_NAME/$new_cluster"

    # 添加shard
    add_shard_to_cluster $cluster_path $new_cluster

    color_print success "新的存档$new_cluster创建完成～"
    color_print info "存档位置: $cluster_path"
    color_print info '要添加/配置Mod的话, 请使用Mod管理面板'
}
