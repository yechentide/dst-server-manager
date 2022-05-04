function backup_cluster() {
    declare -a array=($(generate_cluster_list -c $KLEI_ROOT_DIR $WORLDS_DIR_NAME))
    if [[ ${#array[@]} == 0 ]]; then color_print error '未找到存档!'; return; fi

    declare cluster=''
    rm $ARRAY_PATH
    for cluster in ${array[@]}; do echo $cluster >> $ARRAY_PATH; done
    selector -cq info '请选择一个存档'
    cluster=$(cat $ANSWER_PATH)

    stop_shards_of_cluster $cluster
    time=$(date '+%Y%m%d-%H%M%S')
    cp -r "$KLEI_ROOT_DIR/$WORLDS_DIR_NAME/$cluster" "$BACKUP_DIR/$cluster-$time"
    color_print success "存档 $cluster 已经备份到 $BACKUP_DIR/$cluster-$time"
}
