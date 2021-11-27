function select_cluster() {
    read -p "请输入存档文件夹名字(仅字母): " CLUSTER_NAME
    CLUSTER_DIR=$KLEI_ROOT_DIR/$WORLDS_DIR/$CLUSTER_NAME

    if [[ ! -e $CLUSTER_DIR ]]; then
        generate_cluster
    fi

    start_server
}
function start_server() {
    if [[ $ARCHITECTURE == 64 ]]; then
        tmux new -d -s $DEFAULT_SHARD_MAIN "cd $DST_ROOT_DIR/bin64; ./dontstarve_dedicated_server_nullrenderer_x64 -persistent_storage_root $KLEI_ROOT_DIR -conf_dir $WORLDS_DIR -cluster $CLUSTER_NAME -shard $DEFAULT_SHARD_MAIN -console"
        tmux new -d -s $DEFAULT_SHARD_CAVE "cd $DST_ROOT_DIR/bin64; ./dontstarve_dedicated_server_nullrenderer_x64 -persistent_storage_root $KLEI_ROOT_DIR -conf_dir $WORLDS_DIR -cluster $CLUSTER_NAME -shard $DEFAULT_SHARD_CAVE -console"
    else
        tmux new -d -s $DEFAULT_SHARD_MAIN "cd $DST_ROOT_DIR/bin; ./dontstarve_dedicated_server_nullrenderer -persistent_storage_root $KLEI_ROOT_DIR -conf_dir $WORLDS_DIR -cluster $CLUSTER_NAME -shard $DEFAULT_SHARD_MAIN -console"
        tmux new -d -s $DEFAULT_SHARD_CAVE "cd $DST_ROOT_DIR/bin; ./dontstarve_dedicated_server_nullrenderer -persistent_storage_root $KLEI_ROOT_DIR -conf_dir $WORLDS_DIR -cluster $CLUSTER_NAME -shard $DEFAULT_SHARD_CAVE -console"
    fi
}
function stop_server() {
    tmux send-keys -t $DEFAULT_SHARD_MAIN C-c
    tmux send-keys -t $DEFAULT_SHARD_CAVE C-c
}
function update_server() {
    stopServer
    sleep 10
    ~/Steam/steamcmd.sh +login anonymous +force_install_dir $DST_ROOT_DIR +app_update 343050 validate +quit

    #crontab -e
    #0 6 * * * sh update.sh   # schedule a task for update the server every day at 6:00 am
}
function update_mods() {
    stopServer && sleep 10
    if [[ $ARCHITECTURE == 64 ]]; then
        $DST_ROOT_DIR/bin64/dontstarve_dedicated_server_nullrenderer_x64 -only_update_server_mods
    else
        $DST_ROOT_DIR/bin/dontstarve_dedicated_server_nullrenderer -only_update_server_mods
    fi
}