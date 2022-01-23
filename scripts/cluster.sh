# Parameters:
#   $1: cluster name      例: c01
function delete_cluster() {
    declare -r _accent_color=36
    # stop shard
    stop_shards_of_cluster $1

    yes_or_no warn "确定要删除存档$1?"
    if [[ $answer == 'no' ]]; then
        color_print info '取消删除 ' -n; count_down -d 3
        return 0
    fi

    if [[ ! -e /tmp/deleted_cluster ]]; then mkdir -p /tmp/deleted_cluster; fi
    declare -r _new_path="/tmp/deleted_cluster/$1-$(date '+%Y%m%d-%H%M%S')"
    mv $klei_root_dir/$worlds_dir/$1 $_new_path > /dev/null 2>&1

    if [[ $? ]]; then
        accent_color_print -p 2 success $_accent_color '存档 ' $1 ' 已经移动到 ' $_new_path '，主机关机时会自动删除!'
        color_print info '要是后悔了，主机关机之前还来得及哦～ ' -n; count_down -d 3
    else
        color_print error '似乎出现了什么错误...'
    fi
}

# Return: token         --> $answer
function get_token() {
    answer=''
    while true; do
        read_line info '请输入token: '
        if [[ ${#answer} == 0 ]]; then
            color_print error '你输入token了吗？？？'
            continue
        fi
        # 格式: pds-g^KU_J9MSP3g1^xif7KC......
        if echo $answer | grep -sqv '^pds-g^KU'; then
            color_print error '输入的token不对'
            color_print error '服务器token是以pds-g^KU开头的'
            continue
        fi
        break
    done
    echo "token = $answer"
}

##############################################################################################

# Parameters:
#   $1: cluster path        ~/Klei/worlds/c01
#   $2: shard name          Main
function create_shard() {
    array=('地上世界' '洞穴世界')
    select_one info '该shard是...'

    # 复制shard模板过去
    if [[ $answer == '地上世界' ]]; then
        cp -r $repo_root_dir/templates/shard_forest $1/$2
    else
        cp -r $repo_root_dir/templates/shard_cave $1/$2
    fi

    # 编辑server.ini
    color_print -n warn '如果本世界是主世界的话, 接下来请把is_master选项改成true'; count_down -d 6
    lua $repo_root_dir/scripts/edit_shard_ini.lua $repo_root_dir $1/$2

    # 编辑worldgenoverride.lua
    if [[ $answer == '地上世界' ]]; then
        lua $repo_root_dir/scripts/configure_world.lua $repo_root_dir 'new' "$1/$2" 'true'
    else
        lua $repo_root_dir/scripts/configure_world.lua $repo_root_dir 'new' "$1/$2" 'false'
    fi
}

function create_cluster() {
    color_print info '开始创建新的存档...'

    read_line info '请输入新存档的文件夹名字' warn '(这个名字不是显示在服务器列表的名字)'
    declare -r _new_cluster=$answer
    if generate_list_from_dir -c | grep -sq $_new_cluster; then
        color_print error '该名字已经存在！'
        color_print tip '请换个名字或者先去把旧的存档删了'
        return 0
    fi
    declare -r _cluster_path="$klei_root_dir/$worlds_dir/$_new_cluster"
    color_print info "存档文件夹名字: $_new_cluster"

    # 复制cluster模板过去
    cp -r $repo_root_dir/templates/cluster $_cluster_path

    # 输入token
    declare _token
    get_token
    echo $answer > $_cluster_path/cluster_token.txt

    # 编辑cluster.ini
    lua $repo_root_dir/scripts/edit_cluster_ini.lua $repo_root_dir "$klei_root_dir/$worlds_dir/$_new_cluster"

    # 添加shard
    while true; do
        yes_or_no info '是否要添加地表/洞穴世界?'
        if [[ $answer == 'no' ]]; then break; fi

        color_print warn '注意: 必须要有一个主世界, 最多只能有一个主世界!'
        color_print info '请为这个世界取个名字吧(文件夹名)'
        read_line tip '地面世界的话推荐Forest, 洞穴世界的话推荐Cave, 主世界的话推荐Main'
        if [[ -e $_cluster_path/$answer ]]; then
            color_print error "存档${_new_cluster}里面已存在${$answer}!"
            continue
        fi
        create_shard $_cluster_path $answer
    done

    color_print success "新的存档$_new_cluster创建完成～"
    color_print info "存档位置: $_cluster_path"
    color_print info '要添加/配置Mod的话, 请使用Mod管理面板'
}

function update_world_setting() {
    color_print info '修改世界的配置选项...'

    array=$(generate_list_from_dir -s)
    if [[ ${#array} == 0 ]]; then color_print error '未找到存档!'; return; fi
    select_one info '请选择一个世界'

    declare -r _shard=$answer
    declare -r _shard_path="$klei_root_dir/$worlds_dir/$(echo $_shard | sed 's#-#/#g')"
    stop_shard $_shard

    remove_klei_from_worldgenoverride $_shard_path
    if ! check_shard $_shard_path; then
        return 0
    fi

    if cat $_shard_path/worldgenoverride.lua | grep -sq 'CAVE'; then
        lua $repo_root_dir/scripts/configure_world.lua $repo_root_dir 'update' $_shard_path 'false'
    else
        lua $repo_root_dir/scripts/configure_world.lua $repo_root_dir 'update' $_shard_path 'true'
    fi
}

function update_ini_setting() {
    color_print info '修改存档的配置选项...'

    array=$(generate_list_from_dir -cs)
    if [[ ${#array} == 0 ]]; then color_print error '未找到存档!'; return; fi
    color_print info '选择"存档名"来修改cluster.ini, 选择"存档名-世界名"来修改server.ini'
    select_one info '请选择一个存档'

    if echo $answer | grep -sqv -; then
        declare -r _cluster=$answer
        declare -r _cluster_path="$klei_root_dir/$worlds_dir/$_cluster"
        stop_shards_of_cluster $_cluster

        if ! check_cluster $_cluster_path; then
            accent_color_print warn 36 '这个存档 ' $_cluster ' 不符合该脚本的标准'
            return 0
        fi

        lua $repo_root_dir/scripts/edit_cluster_ini.lua $repo_root_dir $_cluster_path
    else
        declare -r _shard=$answer
        declare -r _shard_path="$klei_root_dir/$worlds_dir/$(echo $_shard | sed 's#-#/#g')"
        stop_shard $_shard

        if ! check_shard $_shard_path; then
            return 0
        fi

        lua $repo_root_dir/scripts/edit_shard_ini.lua $repo_root_dir $_shard_path
    fi
}

##############################################################################################

function cluster_panel() {
    declare _action
    declare -r -a _action_list=('新建存档' '修改存档配置' '修改世界配置' '删除存档' '返回')
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
        array=${_action_list[@]}; select_one info '请从下面选一个'
        declare _action=$answer

        case $_action in
        '新建存档')
            create_cluster
            ;;
        '修改存档配置')
            update_ini_setting
            ;;
        '修改世界配置')
            update_world_setting
            ;;
        '删除存档')
            array=($(generate_list_from_dir -c))
            if [[ ${#array} == 0 ]]; then color_print error '未找到存档!'; continue; fi

            multi_select warn '(多选用空格隔开)请选择你要删除的存档'
            declare _cluster=''
            for _cluster in ${array[@]}; do
                delete_cluster $_cluster
            done
            ;;
        '返回')
            color_print info '即将返回主面板 ' -n; count_down 3
            return 0
            ;;
        *)
            color_print error "${_action}功能暂未写好" -n; count_down -d 3
            ;;
        esac
    done
}
