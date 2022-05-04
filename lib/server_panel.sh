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
            declare -a array=$(generate_cluster_list -cs $KLEI_ROOT_DIR $WORLDS_DIR_NAME)
            if [[ ${#array} == 0 ]]; then color_print error '未找到存档!'; continue; fi

            color_print tip '请确保先启动主世界'
            declare answer=''
            rm $ARRAY_PATH
            for answer in ${array[@]}; do echo $answer >> $ARRAY_PATH; done
            selector -cq tip '选择存档名则会启动该存档下的所有世界, 选择世界名则只会启动这个世界'
            answer=$(cat $ANSWER_PATH)
            if [[ $answer == '返回' ]]; then continue; fi

            # 选择了shard
            if echo $answer | grep -sq -; then
                declare shard_path="$KLEI_ROOT_DIR/$WORLDS_DIR_NAME/$(echo $answer | sed -e "s#-#/#g")"
                if check_shard $shard_path; then
                    start_shard $answer
                fi
                continue
            fi
            # 选择了cluster
            color_print info "将启动存档 $answer 里所有的世界!"
            if ! check_cluster "$KLEI_ROOT_DIR/$WORLDS_DIR_NAME/$answer"; then continue; fi
            declare shard=''
            for shard in $(generate_list_from_cluster $KLEI_ROOT_DIR $WORLDS_DIR_NAME $answer); do
                declare shard_path="$KLEI_ROOT_DIR/$WORLDS_DIR_NAME/$answer/$shard"
                if check_shard $shard_path; then
                    start_shard "$answer-$shard"
                fi
            done
            ;;
        '操作控制台')
            declare -a array=$(generate_server_list -s)
            if [[ ${#array} == 0 ]]; then color_print error '没有运行中的世界!'; continue; fi

            declare answer=''
            rm $ARRAY_PATH
            for answer in ${array[@]}; do echo $answer >> $ARRAY_PATH; done
            selector -q tip '请选择要操作哪个世界的控制台'
            answer=$(cat $ANSWER_PATH)

            console_manager $answer
            ;;
        '关闭服务端')
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
                stop_shard $answer
                continue
            fi
            # 选择了cluster
            declare shard=''
            for shard in $(generate_list_from_cluster $KLEI_ROOT_DIR $WORLDS_DIR_NAME $answer); do
                stop_shard "$answer-$shard"
            done
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
            update_dst -u $DST_ROOT_DIR $V1_MOD_DIR
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
