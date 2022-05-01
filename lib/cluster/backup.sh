function backup_cluster() {
    array=($(generate_list_from_dir -c))
    if [[ ${#array[@]} == 0 ]]; then color_print error '未找到存档!'; return; fi
    select_one info '请选择一个存档'
    declare -r cluster=$answer

    stop_shards_of_cluster $cluster
    time=$(date '+%Y%m%d-%H%M%S')
    cp -r "$KLEI_ROOT_DIR/$WORLDS_DIR/$cluster" "$BACKUP_DIR/$cluster-$time"
    color_print success "存档 $cluster 已经备份到 $BACKUP_DIR/$cluster-$time"
}
