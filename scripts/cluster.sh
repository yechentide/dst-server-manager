# Parameters:
#   $1: 存档文件夹          ~/Klei/worlds
# Return:
#   name of a cluster
#   or error code 1
function select_cluster() {
    if [[ ! -e $1 ]]; then mkdir -p $1; fi
    if [[ $(ls -l $1 | awk '$1 ~ /d/ {print $9}' | wc -l) == 0 ]]; then
        echo ''
        return 0
    fi

    PS3='请输入数字来选择一个存档> '
    declare _selected_cluster
    select _selected_cluster in $(ls -l $1 | awk '$1 ~ /d/ {print $9}'); do break; done

    echo $_selected_cluster
}

# Parameters:
#   $1: $repo_root_dir      ~/DSTServerManager
#   $2: $dst_root_dir       ~/Server
#   $3: $klei_root_dir      ~/Klei
#   $4: worlds derictory    worlds
#   $5: $shard_main_name    Main
#   $6: $shard_cave_name    Cave
function create_cluster() {
    color_print info '开始创建新的世界...'
    declare _new_cluster
    declare _use_multi_server=1     # 0=true, 1=false
    declare _is_main=0              # 0=true, 1=false

    color_print info '是否使用多个主机开服？'
    PS3="$(color_print info '请输入选项数字> ')"
    declare _selected
    select _selected in yes no; do break; done
    if [[ $_selected == 'yes' ]]; then
        _use_multi_server=0
        color_print info '本服务器上的世界，是否为主世界？'
        select _selected in yes no; do break; done
        if [[ $_selected == 'no' ]]; then
            _is_main=1
        fi
    fi


    read -p '请输入新世界的文件夹名字(这个名字不是显示在服务器列表的名字)> ' _new_cluster
    if ls -l $3/$4 | awk '$1 ~ /d/ {print $9}' | grep "$_new_cluster" > /dev/null 2>&1; then
        color_print error '该名字已经存在！'
        return 0
    fi
    mkdir -p $3/$4/$_new_cluster

    # token
    while true; do
        read -p "请输入token: " _token
        if [[ ${#_token} == 0 ]]; then
            color_print error '你输入token了吗？？？'
            continue
        fi
        echo $_token >> $3/$4/$_new_cluster/cluster_token.txt
        break
    done

    if [[ $_use_multi_server == 0 ]]; then
        create_single_level
    else
        create_multi_level $1 $2 $3 $4 $_new_cluster $5 $6
    fi

    color_print info "新的世界$_new_cluster创建完成～"
}

# Parameters:
#   $1: $repo_root_dir      ~/DSTServerManager
#   $2: $dst_root_dir       ~/Server
#   $3: $klei_root_dir      ~/Klei
#   $4: worlds derictory    worlds
#   $5: _new_cluster        cluster name
#   $6: $shard_???_name     Main/Cave
#   $7: _is_main            0 / 1
function create_single_level() {
    # cluster.ini
    configure_cluster_ini $1 $3/$4/$5

    # server.ini
    configure_server_ini $1 $3/$4/$5 $6 $7

    # leveldataoverride.lua
    echo ''; color_print info "开始配置$5/$6世界的设置..."
    if [[ $7 == 0 ]]; then
        configure_level_setting $1/templates/main_worldgenoverride.lua $3/$4/$5/$6/worldgenoverride.lua
    else
        configure_level_setting $1/templates/cave_worldgenoverride.lua $3/$4/$5/$6/worldgenoverride.lua
    fi
}

# Parameters:
#   $1: $repo_root_dir      ~/DSTServerManager
#   $2: $dst_root_dir       ~/Server
#   $3: $klei_root_dir      ~/Klei
#   $4: worlds derictory    worlds
#   $5: _new_cluster        cluster name
#   $6: $shard_???_name     Main/Cave
#   $7: _is_main            0 / 1
function create_multi_level() {
    # cluster.ini
    configure_cluster_ini $1 $3/$4/$5
    
    # server.ini
    configure_server_ini $1 $3/$4/$5 $6 0
    configure_server_ini $1 $3/$4/$5 $7 1

    # leveldataoverride.lua
    echo ''; color_print info '开始配置主世界的设置...'
    configure_level_setting $1/templates/main_worldgenoverride.lua $3/$4/$5/$6/worldgenoverride.lua
    echo ''; color_print info '开始配置洞穴的设置...'
    configure_level_setting $1/templates/cave_worldgenoverride.lua $3/$4/$5/$7/worldgenoverride.lua
}

# Parameters:
#   $1: $repo_root_dir      ~/DSTServerManager
#   $2: cluster derictory   ~/Klei/worlds/???
#   $3: _use_multi_server   0 / 1
#   $4: _is_main            0 / 1
function configure_cluster_ini() {
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

    read -p "开启投票(默认true, 其他选项false): " _answer
    sed -i "s/vote_enabled = \(true\)/vote_enabled = $_answer/g" $2/cluster.ini

    read -p "最大存档快照数(默认6, 可以用来回档): " _answer
    sed -i "s/max_snapshots = \(6\)/max_snapshots = $_answer/g" $2/cluster.ini

    if [[ $3 == 0 ]]; then
        if [[ $4 == 0 ]]; then
            echo '修改bind_ip --> 0.0.0.0'
            bind_ip = 127.0.0.1
            sed -i "s/bind_ip = \(127.0.0.1\)/bind_ip = 0.0.0.0/g" $2/cluster.ini
        else
            read -p "请输入主服务器的ip地址: " _answer
            sed -i "s/master_ip = \(127.0.0.1\)/master_ip = $_answer/g" $2/cluster.ini  
        fi

        read -p "请输入要监听的端口(副服务器将使用此端口来连接主服务器): " _answer
        sed -i "s/master_port = \(10888\)/master_port = $_answer/g" $2/cluster.ini
        color_print info "主服务器和副服务器将使用端口$_answer, 请确保防火墙和安全组设置里打开了端口$_answer"
    fi

    color_print info 'cluster.ini创建完成！'
}

# Parameters:
#   $1: $repo_root_dir      ~/DSTServerManager
#   $2: cluster derictory   ~/Klei/worlds/???
#   $3: $shard_???_name     Main/Cave
#   $4: _is_main            0 / 1
function configure_server_ini() {
    if [[ ! -e $2/$3 ]]; then mkdir -p $2/$3; fi
    if [[ $4 == 0 ]]; then 
        declare -r _default_port=11000
        declare -r _template_file=$1/templates/main_server.ini
    else
        declare -r _default_port=11001
        declare -r _template_file=$1/templates/cave_server.ini
    fi
    declare _answer
    echo ''; color_print info "开始创建$3/server.ini"
    read -p "请输入$3世界端口(默认值$_default_port, 范围2000~65535): " _answer
    sed "s/server_port = \($_default_port\)/server_port = $_answer/g" $_template_file > $2/$4/server.ini
    color_print info "$3世界将使用端口$_answer, 请确保防火墙和安全组设置里打开了端口$_answer " -n, count_down 3 dot
    color_print info "$3/server.ini创建完成！"
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
            declare _name_ch=$(echo $_line | awk '{print $3}' | awk -F ':' '{print $1}')
            declare _name_en=$(echo $_line | awk '{print $1}' | awk -F '=' '{print $1}')
            declare _default_value=$(echo $_line | awk '{print $1}' | awk -F '=' '{print $2}' | awk -F '"' '{print $2}')
            declare _options=$(echo $_line | awk '{print $4}' | sed -e "s/,/  /g")

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
#   $1: setting file          ~/Klei/worlds/???/Main
function change_level_setting() {
    declare _line=''
    declare _skip='true'
    declare _old_ifs=$IFS;
    declare IFS=''

    if [[ ! -e $1/worldgenoverride.lua ]]; then color_print error '未找到配置文件'; return 0; fi
    color_print info '空栏状态下回车，即可跳过'

    cp $1/worldgenoverride.lua $1/worldgenoverride.lua.old
    declare -r _old_file="$1/worldgenoverride.lua.old"
    declare -r _new_file="$1/worldgenoverride.lua"

    while read -u 6 _line; do
        if echo $_line | grep '世界选项' > /dev/null 2>&1; then
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
            declare _name_ch=$(echo $_line | awk '{print $3}' | awk -F ':' '{print $1}')
            declare _name_en=$(echo $_line | awk '{print $1}' | awk -F '=' '{print $1}')
            declare _current_value=$(echo $_line | awk '{print $1}' | awk -F '=' '{print $2}' | awk -F '"' '{print $2}')
            declare _options=$(echo $_line | awk '{print $4}' | sed -e "s/,/  /g")

            echo ''
            color_print 215 '---------- ---------- ----------'
            color_print 172 "${_name_ch}(${_name_en})   当前值: ${_current_value}"
            color_print 180 '可选项目: ' -n
            color_print 186 "${_options}"

            declare _answer
            while true; do
                read -p '> ' _answer
                if [[ ${#_answer} == 0 || $_answer == $_current_value ]]; then
                    color_print 39 "使用当前值: $_current_value"
                    break
                fi

                if echo $_options | grep $_answer > /dev/null 2>&1; then
                    color_print 39 "更改设定为: $_answer"
                    sed -i "s/$_name_en=\"\($_current_value\)\"/$_name_en=\"$_answer\"/" $_new_file
                    break
                fi

                color_print error "输入错误: $_answer, 请检查你的拼写并输入正确的选项"
            done
        fi

    done 6< $_old_file
    IFS=$_old_ifs
    rm $_old_file > /dev/null 2>&1
    color_print info "配置完成，可以修改 ${_new_file} 来手动更改配置"
}

# Parameters:
#   $1: $repo_root_dir     ~/DSTServerManager
#   $2: $dst_root_dir      ~/Server
#   $3: $klei_root_dir     ~/Klei
#   $4: worlds derictory   worlds
#   $5: $SHARD_MAIN        Main
#   $6: $SHARD_CAVE        Cave
function cluster_panel() {
    echo ''
    color_print 70 '>>>>>> 存档管理 <<<<<<'
    display_running_clusters

    declare -r -a _action_list=('新建存档' '更改世界选项' '备份存档' '还原存档' '删除存档' '返回')
    PS3="$(color_print info '[退出或中断操作请直接按 Ctrl加C ]')"$'\n''请输入选项数字> '
    declare _selected
    select _selected in ${_action_list[@]}; do break; done
    if [[ ${#_selected} == 0 ]]; then color_print error '输入错误'; return 0; fi
    
    case $_selected in
    '新建存档')
        create_cluster $1 $2 $3 $4 $5 $6
        ;;
    '更改世界选项')
        declare -r _cluster=$(select_cluster $3/$4)
        if [[ $? == 1 ]]; then color_print error '选择世界时发生错误，请检查输入以及是否有存档'; return 0; fi

        PS3="$(color_print 10 '请输入选项数字> ')"

        echo ''
        color_print info "更改存档配置前，将会关闭世界$_cluster！"
        select _selected in 继续 算了; do break; done
        if [[ $_selected == '算了' ]]; then return 0; fi
        stop_server $_cluster $5 $6

        echo ''
        color_print info '即将开始修改地上的世界选项'
        select _selected in 继续 跳过; do break; done
        if [[ $_selected == '继续' ]]; then
            change_level_setting $3/$4/$_cluster/$5
        fi
        color_print info '即将开始修改地下的世界选项'
        select _selected in 继续 跳过; do break; done
        if [[ $_selected == '继续' ]]; then
            change_level_setting $3/$4/$_cluster/$6
        fi
        color_print info '世界选项修改结束'
        ;;
    #'备份存档')
    #    ;;
    #'还原存档')
    #    ;;
    '删除存档')
        color_print info '当前存档:'
        ls -l $3/$4 | awk '$1 ~ /d/ {print $9}' | sed "s/\n/\s/g"

        declare _answer
        read -p "请输入要删除的存档名字(可多选，用1个空格隔开): " _answer
        if [[ ${#_answer} == 0 ]]; then
            color_print error '无输入，返回上一级'
            return 0
        fi
        declare _result=1
        for _cluster in $_answer; do
            if $(mv $3/$4/$_cluster /tmp > /dev/null 2>&1); then
                _result=0
            else
                color_print error "未找到存档$_cluster"
            fi  
        done
        if [[ $_result == 0 ]]; then
            color_print info '目标存档已经移动到/tmp，主机关机时会自动删除'
            color_print info '要是后悔了，主机关机之前还来得及哦～'
        fi
        ;;
    '返回')
        return 0
        ;;
    *)
        color_print error "${_selected}功能暂未写好" -n; count_down 3 dot
        return 0
        ;;
    esac
    color_print info '即将返回主面板 ' -n; count_down 3
}

