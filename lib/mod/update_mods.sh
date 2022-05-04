function update_mods() {
    color_print info '即将开始下载/更新Mod...'
    color_print info "一次性指定的Mod越多, 下载越耗时间, 如果1次没下载完, 请使用'更新Mod'功能来继续下载"
    count_down -n 6

    tmux new -s 'update_mods' "cd $DST_ROOT_DIR/bin64; ./dontstarve_dedicated_server_nullrenderer_x64 -only_update_server_mods -ugc_directory $UGC_DIR -persistent_storage_root $REPO_ROOT_DIR/.cache/.klei -conf_dir xxxxxx -cluster tmp -shard master"
    
    color_print info 'Mod下载/更新结束!'
    show_mods_list $V1_MOD_DIR $V2_MOD_DIR $UGC_DIR

    count_down 3
}