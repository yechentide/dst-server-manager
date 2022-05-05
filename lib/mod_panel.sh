function mod_panel() {
    declare -r -a action_list=('下载Mod' '添加Mod' '配置Mod' '更新Mod' '删除Mod')

    while true; do
        echo ''
        color_print 70 '>>>>>> Mod管理 <<<<<<'
        display_running_clusters
        color_print info '[退出或中断操作请直接按 Ctrl加C ]'

        declare action=''
        rm $ARRAY_PATH
        for action in ${action_list[@]}; do echo $action >> $ARRAY_PATH; done
        selector -cq info '请从下面选一个'
        action=$(cat $ANSWER_PATH)

        case $action in
        '下载Mod')
            add_mods_to_file
            update_mods
            ;;
        '添加Mod')
            configure_mods_in_cluster 'add'
            ;;
        '配置Mod')
            configure_mods_in_cluster 'update'
            ;;
        '更新Mod')
            update_mods
            ;;
        '删除Mod')
            delete_mods
            ;;
        '返回')
            color_print info '即将返回主面板'
            sleep 1
            return 0
            ;;
        *)
            color_print -n error "${action}功能暂未写好" ; count_down -d 3
            ;;
        esac
    done
}
