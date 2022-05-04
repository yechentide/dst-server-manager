function cluster_panel() {
    declare -r -a action_list=('新建存档' '导入本地存档' '修改存档配置' '修改世界配置' '配置管理名单' '配置白名单' '配置黑名单' '备份存档' '删除存档' '返回')
    # ToDo: 导入存档 '备份存档' '还原存档'

    while true; do
        echo ''
        color_print 70 '>>>>>> 存档管理 <<<<<<'
        display_running_clusters
        array=()
        answer=''

        color_print info '[退出或中断操作请直接按 Ctrl加C ]'
        color_print tip '存档是指包含了地表/洞穴世界的文件夹(存档=cluster)'
        color_print tip '世界是指1个地表世界或者1个洞穴世界的文件夹(世界=shard)'
        array=${action_list[@]}; select_one info '请从下面选一个'
        declare action=$answer

        case $action in
        '新建存档')
            create_cluster
            ;;
        '导入本地存档')
            import_local_save_data
            ;;
        '修改存档配置')
            update_ini_setting
            ;;
        '修改世界配置')
            update_world_setting
            ;;
        '配置管理名单')
            edit_list op
            ;;
        '配置白名单')
            edit_list white
            ;;
        '配置黑名单')
            edit_list black
            ;;
        '备份存档')
            backup_cluster
            ;;
        '删除存档')
            array=($(generate_list_from_dir -c))
            if [[ ${#array[@]} == 0 ]]; then color_print error '未找到存档!'; continue; fi

            multi_select warn '(多选用空格隔开)请选择你要删除的存档'
            declare cluster=''
            for cluster in ${array[@]}; do
                delete_cluster $cluster
            done
            ;;
        '返回')
            color_print info '即将返回主面板'
            sleep 1
            return 0
            ;;
        *)
            color_print error "${action}功能暂未写好" -n; count_down 3
            ;;
        esac
    done
}
