function update_repo() {
    color_print info '开始更新脚本仓库...'
    if [[ -e $CACHE_DIR/.need_update ]]; then
        rm $CACHE_DIR/.need_update
    fi
    git -C $REPO_ROOT_DIR checkout .
    git -C $REPO_ROOT_DIR pull
    if [[ $? == 1 ]]; then
        color_print error '脚本仓库更新失败, 请检查git命令是否可用, 也有可能远程仓库目前无法访问'
        color_print error "当前的远程仓库URL: $(git remote -v | awk '{print $2}' | uniq)"
        return 0
    fi
    color_print success '脚本仓库更新完毕!请重新执行脚本~'
    exit 0
}

function change_git_branch() {
    declare -r current_branch=$(git -C $REPO_ROOT_DIR branch | grep '*' | awk '{print $2}')
    declare target_branch='dev'
    if [[ $current_branch != 'main' ]]; then target_branch='main'; fi
    if ! git -C $REPO_ROOT_DIR branch -a | grep -sq "$target_branch"; then
        color_print error "$target_branch 分支似乎不存在..."
        return 0
    fi

    git -C $REPO_ROOT_DIR fetch
    git -C $REPO_ROOT_DIR checkout $target_branch

    color_print info "脚本仓库已经切换到 $target_branch 分支!"
}

function other_panel() {
    declare -r -a action_list=('脚本简介' '更新脚本' '切换仓库分支' '文件夹结构')

    while true; do
        echo ''
        color_print 70 '>>>>>> ?????? <<<<<<'
        display_running_clusters
        color_print info '[退出或中断操作请直接按 Ctrl加C ]'

        declare action=''
        rm $ARRAY_PATH
        for action in ${action_list[@]}; do echo $action >> $ARRAY_PATH; done
        selector -cq info '请从下面选一个'
        action=$(cat $ANSWER_PATH)

        case $action in
        '脚本简介')
            script_info
            ;;
        '更新脚本')
            update_repo
            ;;
        '切换仓库分支')
            change_git_branch
            ;;
        '文件夹结构')
            print_dir_struct $REPO_ROOT_DIR
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
