function update_mod() {
    #if ls $UGC_DIR | grep -sq .acf$; then rm $UGC_DIR/*.acf; fi

    declare -r session_name='update_mods'
    tmux new -d -s "$session_name" "cd $DST_ROOT_DIR/bin64; ./dontstarve_dedicated_server_nullrenderer_x64 -only_update_server_mods -ugc_directory $UGC_DIR -persistent_storage_root $REPO_ROOT_DIR/.cache/.klei -conf_dir xxxxxx -cluster tmp -shard master"
    declare -r time_out=360
    color_print info '正在下载/更新Mod...'
    color_print info "一次性指定的Mod越多, 下载越耗时间, 请等待$time_out秒"
    declare i
    for i in $(seq 1 $time_out); do
        sleep 1
        #if tmux capture-pane -t "$session_name" -p -S - | grep -sq 'FinishDownloadingServerMods Complete'; then
        if ! tmux ls 2>&1 | grep -sq $session_name; then
            copy_all_modinfo
            color_print success 'Mod下载/更新完成!'
            return 0
        fi
    done
    #tmux kill-session -t "$session_name"
    color_print error 'Mod下载/更新失败...'
}
