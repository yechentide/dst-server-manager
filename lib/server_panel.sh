function start_server() {
    declare -a array=$(generate_cluster_list -cs $KLEI_ROOT_DIR $WORLDS_DIR_NAME)
    if [[ ${#array} == 0 ]]; then color_print error '未找到存档!'; sleep 1; return 0; fi

    color_print tip '请确保先启动主世界'
    declare answer=''
    rm $ARRAY_PATH
    for answer in ${array[@]}; do echo $answer >> $ARRAY_PATH; done
    selector -cq tip '选择存档名则会启动该存档下的所有世界, 选择世界名则只会启动这个世界'
    answer=$(cat $ANSWER_PATH)
    if [[ $answer == '返回' ]]; then return 0; fi

    # 选择了shard
    if echo $answer | grep -sq -; then
        declare shard_path="$KLEI_ROOT_DIR/$WORLDS_DIR_NAME/$(echo $answer | sed -e 's#-\([^-]*\)$#/\1#g')"
        if check_shard $shard_path; then
            start_shard $answer
        fi
        return 0
    fi
    # 选择了cluster
    color_print info "将启动存档 $answer 里所有的世界!"
    if ! check_cluster "$KLEI_ROOT_DIR/$WORLDS_DIR_NAME/$answer"; then return 0; fi
    declare shard=''
    for shard in $(generate_list_from_cluster $KLEI_ROOT_DIR $WORLDS_DIR_NAME $answer); do
        declare shard_path="$KLEI_ROOT_DIR/$WORLDS_DIR_NAME/$answer/$shard"
        if check_shard $shard_path; then
            start_shard "$answer-$shard"
        fi
    done
}

function enter_console() {
    declare -a array=$(generate_server_list -s)
    if [[ ${#array} == 0 ]]; then color_print error '没有运行中的世界!'; sleep 1; return 0; fi

    declare answer=''
    rm $ARRAY_PATH
    for answer in ${array[@]}; do echo $answer >> $ARRAY_PATH; done
    selector -q tip '请选择要操作哪个世界的控制台'
    answer=$(cat $ANSWER_PATH)

    console_manager $answer
}

function stop_server() {
    declare -a array=$(generate_server_list -cs)
    if [[ ${#array} == 0 ]]; then color_print error '没有运行中的世界!'; sleep 1; return 0; fi

    declare answer=''
    rm $ARRAY_PATH
    for answer in ${array[@]}; do echo $answer >> $ARRAY_PATH; done
    selector -cq tip '选择存档名则会关闭该存档下的所有世界, 选择世界名则只会关闭这个世界'
    answer=$(cat $ANSWER_PATH)
    if [[ $answer == '返回' ]]; then return 0; fi

    # 选择了shard
    if echo $answer | grep -sq -; then
        stop_shard $answer
        return 0
    fi
    # 选择了cluster
    declare shard=''
    for shard in $(generate_list_from_cluster $KLEI_ROOT_DIR $WORLDS_DIR_NAME $answer); do
        stop_shard "$answer-$shard"
    done
}

function server_panel() {
    declare -r -a action_list=('启动服务端' '操作控制台' '关闭服务端' '重启服务端' '更新服务端')

    while true; do
        echo ''
        color_print 70 '>>>>>> 服务端管理 <<<<<<'
        display_running_clusters
        color_print info '[退出或中断操作请直接按 Ctrl加C ]'

        declare action=''
        rm $ARRAY_PATH
        for action in ${action_list[@]}; do echo $action >> $ARRAY_PATH; done
        selector -cq info '请从下面选一个'
        action=$(cat $ANSWER_PATH)

        case $action in
        '启动服务端')
            start_server
            ;;
        '操作控制台')
            enter_console
            ;;
        '关闭服务端')
            stop_server
            ;;
        '重启服务端')
            declare -a array=$(generate_server_list -cs)
            if [[ ${#array} == 0 ]]; then color_print error '没有运行中的世界!'; continue; fi

            declare answer=''
            rm $ARRAY_PATH
            for answer in ${array[@]}; do echo $answer >> $ARRAY_PATH; done
            selector -cq tip '选择存档名则会关闭该存档下的所有世界, 选择世界名则只会关闭这个世界'
            answer=$(cat $ANSWER_PATH)
            if [[ $answer == '返回' ]]; then continue; fi

            # 选择了shard
            if echo $answer | grep -sq -; then
                restart_shard $answer
                continue
            fi
            # 选择了cluster
            declare shard=''
            for shard in $(generate_list_from_cluster $KLEI_ROOT_DIR $WORLDS_DIR_NAME $answer); do
                restart_shard "$answer-$shard"
            done
            ;;
        '更新服务端')
            color_print warn '升级服务端之前，将会关闭所有运行中的世界！'
            confirm warn '是否关闭所有运行中的世界, 并更新服务端？'
            if [[ $(cat $ANSWER_PATH) == 'no' ]]; then
                color_print -n info '取消升级 '; count_down 3
                continue
            fi
            # To Fix: 升级服务端会导致dedicated_server_mods_setup.lua被清空, 然后Mod会无效
            cp $V1_MOD_DIR/dedicated_server_mods_setup.lua $V1_MOD_DIR/dedicated_server_mods_setup.lua.bak
            stop_all_shard

            update_dst -u $DST_ROOT_DIR
            cp $V1_MOD_DIR/dedicated_server_mods_setup.lua.bak $V1_MOD_DIR/dedicated_server_mods_setup.lua
            ;;
        '返回')
            color_print info '即将返回主面板'
            sleep 1
            return 0
            ;;
        *)
            color_print -n error "${action}功能暂未写好"; count_down 3
            ;;
        esac
    done
}
