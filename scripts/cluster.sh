# Parameters:
#   $1: 存档文件夹      ~/Klei/worlds
# Return:
#   name of a cluster
#   or error code 1
function select_cluster() {
    if [[ ! -e $1 ]]; then mkdir -p $1; fi
    if [[ $(ls $1 | wc -l) == 0 ]]; then
        color_print error '未找到任何存档, 请先新建一个存档！'
        return 1
    fi

    PS3='请输入数字来选择一个存档> '
    declare _selected_cluster
    select _selected_cluster in $(ls -l $1 | awk '$1 ~ /d/ {print $9}'); do break; done

    if ls -l $1 | awk '$1 ~ /d/ {print $9}' | grep "$_selected_cluster" > /dev/null 2>&1; then
        echo $_selected_cluster
    else
        return 1
    fi
}

# Parameters:
#   $1: $repo_root_dir     ~/DSTServerManager
#   $2: $dst_root_dir      ~/Server
#   $3: $klei_root_dir     ~/Klei
#   $4: worlds derictory   worlds
#   $5: $SHARD_MAIN        Main
#   $6: $SHARD_CAVE        Cave
function create_cluster() {
    color_print info '开始创建新的世界...'
    declare _new_cluster
    read -p '请输入新世界的文件夹名字(这个名字不是显示在服务器列表的名字)> ' _new_cluster
    if ls -l $3/$4 | awk '$1 ~ /d/ {print $9}' | grep "$_new_cluster" > /dev/null 2>&1; then
        color_print error '该名字已经存在！'
        return 1
    fi

    if [[ ! -e $3/$4/$_new_cluster/$5 ]]; then mkdir -p $3/$4/$_new_cluster/$5; fi
    if [[ ! -e $3/$4/$_new_cluster/$6 ]]; then mkdir -p $3/$4/$_new_cluster/$6; fi

    # token
    while true; do
        read -p "请输入token: " token
        if [[ ${#token} == 0 ]]; then
            color_print error '你输入token了吗？？？'
            continue
        fi
        echo $token >> $3/$4/$_new_cluster/cluster_token.txt
        break
    done

    # cluster.ini, server.ini
    configure_cluster_setting $1 $3/$4/$_new_cluster $5 $6
    # leveldataoverride.lua
    echo ''; color_print info '开始配置主世界的设置...'
    configure_level_setting $1/templates/main_worldgenoverride.lua $3/$4/$_new_cluster/$5/worldgenoverride.lua
    echo ''; color_print info '开始配置洞穴的设置...'
    configure_level_setting $1/templates/cave_worldgenoverride.lua $3/$4/$_new_cluster/$6/worldgenoverride.lua
    
    # mods
    #PS3='马上添加mod嘛？请输入数字> '
    #select answer in 添加mod 不了; do break; done
    #if [[ $answer == '添加mod' ]]; then
    #    add_mods $2 $3/$4 $5 $6 $_new_cluster
    #fi

    color_print info '新的世界创建完成～'
}

# Parameters:
#   $1: $repo_root_dir      ~/DSTServerManager
#   $2: cluster derictory   ~/Klei/worlds/???
#   $3: $SHARD_MAIN         Main
#   $4: $SHARD_CAVE         Cave
function configure_cluster_setting() {
    # generate cluster.ini
    echo ''; color_print info '开始创建cluster.ini'
    color_print info '空栏状态下回车，即可使用默认值'
    cp $1/templates/cluster.ini $2/cluster.ini

    declare _answer

    read -p "请输入服务器名字(将会显示在服务器列表): " _answer
    sed -i "s/cluster_name = \(鸽子们的摸鱼日常\)/cluster_name = $_answer/g" $2/cluster.ini

    read -p "请输入服务器介绍(将会显示在服务器列表): " _answer
    sed -i "s/cluster_description = \(咕咕咕！\)/cluster_description = $_answer/g" $2/cluster.ini

    read -p "请输入服务器密码(不设密码请空着): " _answer
    sed -i "s/cluster_password = \(password\)/cluster_password = $_answer/g" $2/cluster.ini

    # social 休闲 cooperative 合作 competitive 竞赛 madness 疯狂
    read -p "请输入服务器风格(默认cooperative, 其他选项: competitive social madness): " _answer
    sed -i "s/cluster_intention = \(cooperative\)/cluster_intention = $_answer/g" $2/cluster.ini

    # endless 无尽 survival 生存 wilderness 荒野 lavaarena 熔炉 quagmire 暴食
    read -p "请输入游戏模式(默认survival, 其他选项:endless wilderness): " _answer
    sed -i "s/game_mode = \(survival\)/game_mode = $_answer/g" $2/cluster.ini

    read -p "请输入最大玩家人数(默认6): " _answer
    sed -i "s/max_players = \(6\)/max_players = $_answer/g" $2/cluster.ini

    read -p "是否开启pvp(默认false, 其他选项true): " _answer
    sed -i "s/pvp = \(false\)/pvp = $_answer/g" $2/cluster.ini

    read -p "开启无人暂停(默认true, 其他选项false): " _answer
    sed -i "s/pause_when_empty = \(true\)/pause_when_empty = $_answer/g" $2/cluster.ini

    read -p "开启投票(true, 其他选项false): " _answer
    sed -i "s/vote_enabled = \(true\)/vote_enabled = $_answer/g" $2/cluster.ini

    read -p "最大存档快照数(默认6, 可以用来回档): " _answer
    sed -i "s/max_snapshots = \(6\)/max_snapshots = $_answer/g" $2/cluster.ini

    color_print info 'cluster.ini创建完成！'

    # generate Main/server.ini
    echo ''; color_print info "开始创建$3/server.ini"
    read -p "请输入主世界端口(默认值11000, 范围2000~65535): " _answer
    sed "s/server_port = \(11000\)/server_port = $_answer/g" $1/templates/main_server.ini > $2/$3/server.ini
    color_print info "$3/server.ini创建完成！"

    # generate Cave/server.ini
    echo ''; color_print info "开始创建$4/server.ini"
    read -p "请输入洞穴的端口(默认值11000, 范围2000~65535): " _answer
    sed "s/server_port = \(11001\)/server_port = $_answer/g" $1/templates/cave_server.ini > $2/$4/server.ini
    color_print info "$4/server.ini创建完成！"
}

# Parameters:
#   $1: input template       ~/DSTServerManager/templates/???.lua
#   $2: output file          ~/Klei/worlds/???/Main/worldgenoverride
function configure_level_setting() {
    declare _line=''
    declare _skip='false'
    declare _old_ifs=$IFS;
    declare IFS=''

    if [[ -e $2 ]]; then rm $2; color_print info '配置文件已存在，执行删除操作...'; sleep 1; fi
    color_print info '空栏状态下回车，即可使用默认值'

    while read -u 6 _line; do
        if [[ $_skip == 'true' ]]; then
            echo $_line >> $2
            continue
        fi
        if [[ ${_line:0:8} == '    -->>' ]]; then
            echo $_line >> $2
            _skip='true'
            continue
        fi


        if [[ ${_line:0:7} == '    -- ' ]]; then
            echo ''; echo '========== ========== ========== ========== ========== =========='
            echo ${_line:7}
        fi

        if [[ ${_line:0:8} == '        ' ]]; then
            declare -r _name_ch=$(echo $_line | awk '{print $3}' | awk -F ':' '{print $1}')
            declare -r _name_en=$(echo $_line | awk '{print $1}' | awk -F '=' '{print $1}')
            declare -r _default_value=$(echo $_line | awk '{print $1}' | awk -F '=' '{print $2}' | awk -F '"' '{print $2}')
            declare -r _options=$(echo $_line | awk '{print $4}' | sed -e "s/,/  /g")

            echo ''
            color_print 215 '---------- ---------- ----------'
            color_print 172 "${_name_ch}(${_name_en})   默认值: ${_default_value}"
            color_print 180 '可选项目: ' -n
            color_print 186 "${_options}"

            declare _answer
            while true; do
                read -p '> ' _answer
                if [[ ${#_answer} == 0 ]]; then
                    color_print 39 "使用默认值: $_default_value"
                    echo $_line >> $2
                    break
                fi

                if echo $_options | grep $_answer > /dev/null 2>&1; then
                    color_print 39 "当前设定: $_answer"
                    echo $_line | sed -e "s/$_default_value/$_answer/" >> $2
                    break
                fi

                color_print error "输入错误: $_answer, 请检查你的拼写并输入正确的选项"
            done
        else
            echo $_line >> $2
        fi
    done 6< $1
    IFS=$_old_ifs
    color_print info "配置完成，可以修改 ${2} 来手动更改配置"
}

# Parameters:
#   $1: setting file          ~/Klei/worlds/???/Main/worldgenoverride
function change_level_setting() {
    declare _line=''
    declare _skip='true'
    declare _old_ifs=$IFS;
    declare IFS=''

    if [[ ! -e $1 ]]; then color_print error '未找到配置文件'; return 1; fi
    color_print info '空栏状态下回车，即可跳过'

    while read -u 6 _line; do
        if echo $_line | grep '世界生成' > /dev/null 2>&1; then
            _skip='false'
            echo ''; echo '========== ========== ========== ========== ========== =========='
            echo ${_line:7}
        fi
        if [[ ${_line:0:8} == '    -->>' ]]; then
            _skip='true'
            continue
        fi

        if [[ $_skip == 'true' ]]; then continue; fi

        if [[ ${_line:0:8} == '        ' ]]; then
            declare -r _name_ch=$(echo $_line | awk '{print $3}' | awk -F ':' '{print $1}')
            declare -r _name_en=$(echo $_line | awk '{print $1}' | awk -F '=' '{print $1}')
            declare -r _current_value=$(echo $_line | awk '{print $1}' | awk -F '=' '{print $2}' | awk -F '"' '{print $2}')
            declare -r _options=$(echo $_line | awk '{print $4}' | sed -e "s/,/  /g")

            echo ''
            color_print 215 '---------- ---------- ----------'
            color_print 172 "${_name_ch}(${_name_en})   当前值: ${_current_value}"
            color_print 180 '可选项目: ' -n
            color_print 186 "${_options}"

            declare _answer
            while true; do
                read -p '> ' _answer
                if [[ ${#_answer} == 0 ]]; then
                    color_print 39 "使用当前值: $_current_value"
                    break
                fi

                if echo $_options | grep $_answer > /dev/null 2>&1; then
                    color_print 39 "更改设定为: $_answer"
                    sed -i "s/$_name_en=\"\($_current_value\)\"/$_name_en=\"$_answer\"/"
                    break
                fi

                color_print error "输入错误: $_answer, 请检查你的拼写并输入正确的选项"
            done
        fi

    done 6< $1
    IFS=$_old_ifs
    color_print info "配置完成，可以修改 ${1} 来手动更改配置"
}

# Parameters:
#   $1: $repo_root_dir     ~/DSTServerManager
#   $2: $dst_root_dir      ~/Server
#   $3: $klei_root_dir     ~/Klei
#   $4: worlds derictory   worlds
#   $5: $SHARD_MAIN        Main
#   $6: $SHARD_CAVE        Cave
function cluster_panel() {
    declare -r -a _action_list=('新建存档' '世界设置' '备份存档' '还原存档' '删除存档' '返回')
    PS3="$(color_print info '[退出或中断操作请直接按 Ctrl加C ]')"$'\n''请输入选项数字> '
    declare _selected
    select _selected in ${_action_list[@]}; do break; done
    if [[ ${#_selected} == 0 ]]; then color_print error '输入错误'; return 1; fi
    
    case $_selected in
    '新建存档')
        create_cluster $1 $2 $3 $4 $5 $6
        ;;
    '世界选项')
        declare -r _cluster=$(select_cluster $3 $4)
        if [[ $? == 1 ]]; then color_print error '选择世界时发生错误，请检查输入以及是否有存档'; return 1; fi
        color_print info "更改存档配置前，将会关闭世界$_cluster！"
        PS3="$(color_print info '请输入选项数字> ')"
        select _selected in 继续 算了; do break; done
        if [[ $_selected == '算了' ]]; then return 0; fi
        stop_server $_cluster $5 $6

        PS3="$(color_print info '即将开始修改地上的世界选项，请输入选项数字> ')"
        select _selected in 继续 跳过; do break; done
        if [[ $_selected == '继续' ]]; then
            change_level_setting $3/$4/$_cluster/$5/worldgenoverride.lua
        fi
        PS3="$(color_print info '即将开始修改地下的世界选项，请输入选项数字> ')"
        select _selected in 继续 跳过; do break; done
        if [[ $_selected == '继续' ]]; then
            change_level_setting $3/$4/$_cluster/$6/worldgenoverride.lua
        fi
        color_print info '世界选项修改结束'
        ;;
    #'备份存档')
    #    ;;
    #'还原存档')
    #    ;;
    '删除存档')
        color_print info '当前存档:'
        ls -l . | awk '$1 ~ /d/ {print $9}' | sed "s/\n/\s/g"

        declare _answer
        read -p "请输入要删除的存档名字(可多选，用1个空格隔开): " _answer
        declare _cluster in $_answer; do
            mv $3/$4/$_cluster /tmp
        done
        color_print info '目标存档已经移动到/tmp，主机关机时会自动删除'
        color_print info '要是后悔了，主机关机之前还来得及哦～'
        ;;
    '返回')
        return 0
        ;;
    *)
        color_print error "${_selected}功能暂未写好"
        return 1
        ;;
    esac
    color_print info '即将返回主面板 ' -n; count_down 3
}
