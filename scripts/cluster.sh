# Parameters:
#   $1: 存档文件夹          ~/Klei/worlds
# Return:
#   返回一行字符串。例子: c01 c02 c03
function generate_cluster_list_from_dir() {
    find $1 -maxdepth 2 -type d | sed -e "s#$1##g" | sed -e "s#^/##g" | grep / | sed -e "s#/#-#g" | awk -F- '{print $1}' | sort | uniq
}

# Parameters:
#   $1: cluster name(在函数内部会更改这个参数原来位置的值), 注意传进来的是变量名(也就是不加$)
#   $2: 存档文件夹          ~/Klei/worlds
function select_cluster_from_dir() {
    declare -n _tmp="$1"
    declare -a _shard_list=$(generate_cluster_list_from_dir "$2")
    if [[ ${#_shard_list} -gt 0 ]]; then
        select_one _shard_list _tmp
    else
        return 1
    fi
}

# Parameters:
#   $1: input   (在函数内部会更改这个参数原来位置的值), 注意传进来的是变量名(也就是不加$)
#   $2: color
#   $3: message
#   $4: color(可省略)
#   $5: message(可省略)
function read_line() {
    color_print $2 "$3"
    if [[ $# == 5 ]]; then
        color_print $4 "$5"
    fi
    echo -n '> '
    declare -n _tmp="$1"
    read _tmp
}

##############################################################################################

#function check_port_usage_of_ubuntu() {
#    # 检测防火墙端口开放状态
#    # 提示配置安全组
#
#    # Ubuntu:
#    # sudo ufw status
#    # Status: inactive
#    # Status: active
#    # sudo ufw allow 6666/udp
#    # 6666/udp                   ALLOW       Anywhere
#    # 6666/udp (v6)              ALLOW       Anywhere (v6)
#    if [[ $(sudo ufw status | grep active) ]]; then
#        color_print info '此主机已经开启防火墙！'
#        color_print info '请注意开放对应的UDP端口'
#        color_print info '需要在云服供应商的网页上配置安全组规则, 并在主机上配置防火墙'
#    fi
#}

# Parameters:
#   $1: 存档所在文件夹          ~/Klei/worlds
#   $2: 存档名字               c01
function delete_cluster() {
    # stop shard
    declare -a _shard_list=$(generate_shard_list_from_tmux | grep ^$2)
    if [[ ${#_shard_list} -gt 0 ]]; then
        declare _shard
        for _shard in $_shard_list; do
            echo "stop $_shard..."
            stop_shard $_shard
        done
    fi

    declare _answer
    yes_or_no _answer warn "确定要删除存档$2?"
    if [[ $_answer == 'no' ]]; then
        color_print info '取消删除 ' -n; count_down 3 dot
        return 0
    fi

    declare -r _new_path="/tmp/$2-$(date '+%Y%m%d-%H%M%S')"
    mv $1/$2 $_new_path > /dev/null 2>&1

    if [[ $? ]]; then
        color_print success "存档 $2 已经移动到$_new_path，主机关机时会自动删除! "
        color_print info '要是后悔了，主机关机之前还来得及哦～ ' -n; count_down 3 dot
    else
        color_print error '似乎出现了什么错误...'
    fi
}

# Parameters:
#   $1: token (在函数内部会更改这个参数原来位置的值), 注意传进来的是变量名(也就是不加$)
function get_token() {
    declare -n _tmp_token="$1"
    while true; do
        read_line _tmp_token info '请输入token: '
        if [[ ${#_tmp_token} == 0 ]]; then
            color_print error '你输入token了吗？？？'
            continue
        fi
        # pds-g^KU_J9MSP3g1^xif7KCbh91B3UMjQACFCYCHre2g/tGCZeYrjQ5wkVtc=
        if echo $_tmp_token | grep -sqv '^pds-g^KU'; then
            color_print error '输入的token不对'
            color_print error '服务器token是以pds-g^KU开头的'
            continue
        fi
        break
    done
    echo "token = $_tmp_token"
}

##############################################################################################

# Parameters:
#   $1: $repo_root_dir      ~/DSTServerManager
#   $2: cluster derictory   ~/Klei/worlds/???
#   $3: _use_multi_server   yes / no
#   $4: _is_main_server     yes / no
function configure_cluster_ini() {
    echo ''
    color_print info '开始创建cluster.ini'
    color_print info '空栏状态下回车，即可使用默认值'
    cp $1/templates/cluster.ini $2/cluster.ini

    declare _answer

    while true; do
        read_line _answer 36 '请输入服务器名字(将会显示在服务器列表): '
        if [[ ${#_answer} == 0 ]]; then color_print error '输入错误'; else break; fi
    done
    color_print 39 "服务器名字: $_answer"
    sed -i "s/cluster_name = \(鸽子们的摸鱼日常\)/cluster_name = $_answer/g" $2/cluster.ini

    read_line _answer 36 '请输入服务器介绍(将会显示在服务器列表): '
    color_print 39 "服务器介绍: $_answer"
    sed -i "s/cluster_description = \(咕咕咕！\)/cluster_description = $_answer/g" $2/cluster.ini

    read_line _answer 36 '请输入服务器密码(不设密码请空着): '
    color_print 39 "服务器密码: $_answer"
    sed -i "s/cluster_password = \(password\)/cluster_password = $_answer/g" $2/cluster.ini

    while true; do
        # social 休闲 cooperative 合作 competitive 竞赛 madness 疯狂
        read_line _answer 36 '请输入服务器风格(默认为cooperative(合作), 其他选项: competitive(竞赛) social(休闲) madness(疯狂))' warn '请输入英文'
        if [[ ${#_answer} == 0 ]]; then _answer='cooperative'; break; fi
        if echo 'social cooperative competitive madness' | grep -sqv $_answer; then color_print error '输入错误'; else break; fi
    done
    color_print 39 "服务器风格: $_answer"
    sed -i "s/cluster_intention = \(cooperative\)/cluster_intention = $_answer/g" $2/cluster.ini

    while true; do
        # endless 无尽 survival 生存 wilderness 荒野 lavaarena 熔炉 quagmire 暴食
        read_line _answer 36 '请输入游戏模式(默认为survival(生存), 其他选项:endless(无尽) wilderness(荒野)): '
        if [[ ${#_answer} == 0 ]]; then _answer='survival'; break; fi
        if echo 'endless survival wilderness' | grep -sqv $_answer; then color_print error '输入错误'; else break; fi
    done
    color_print 39 "游戏模式: $_answer"
    sed -i "s/game_mode = \(survival\)/game_mode = $_answer/g" $2/cluster.ini

    read_line _answer 36 '请输入最大玩家人数(默认6): '
    if [[ ${#_answer} == 0 ]]; then _answer='6'; fi
    color_print 39 "最大玩家人数: $_answer"
    sed -i "s/max_players = \(6\)/max_players = $_answer/g" $2/cluster.ini

    read_line _answer 36 '是否开启pvp(默认false, 其他选项true): '
    if [[ ${#_answer} == 0 ]]; then _answer='false'; fi
    color_print 39 "pvp: $_answer"
    sed -i "s/pvp = \(false\)/pvp = $_answer/g" $2/cluster.ini

    read_line _answer 36 '开启无人暂停(默认true, 其他选项false): '
    if [[ ${#_answer} == 0 ]]; then _answer='true'; fi
    color_print 39 "无人暂停: $_answer"
    sed -i "s/pause_when_empty = \(true\)/pause_when_empty = $_answer/g" $2/cluster.ini

    read_line _answer 36 '开启投票(默认true, 其他选项false): '
    if [[ ${#_answer} == 0 ]]; then _answer='true'; fi
    color_print 39 "投票: $_answer"
    sed -i "s/vote_enabled = \(true\)/vote_enabled = $_answer/g" $2/cluster.ini

    read_line _answer 36 '最大存档快照数(默认6, 可以用来回档): '
    if [[ ${#_answer} == 0 ]]; then _answer='6'; fi
    color_print 39 "最大存档快照数: $_answer"
    sed -i "s/max_snapshots = \(6\)/max_snapshots = $_answer/g" $2/cluster.ini

    if [[ $3 == 'yes' ]]; then
        if [[ $4 == 'yes' ]]; then
            color info '修改bind_ip --> 0.0.0.0'
            sed -i "s/bind_ip = \(127.0.0.1\)/bind_ip = 0.0.0.0/g" $2/cluster.ini
        else
            read_line _answer 36 '请输入主服务器的ip地址: '
            color_print 39 "主服务器的ip地址: $_answer"
            sed -i "s/master_ip = \(127.0.0.1\)/master_ip = $_answer/g" $2/cluster.ini
        fi

        read_line _answer 36 '请输入要服务器之间的通信端口' warn '请确保两边的服务器都开启这个端口(UDP)'
        color_print warn "主服务器和副服务器将使用UDP端口$_answer, 请确保防火墙和安全组设置里打开了UDP端口$_answer"
        sed -i "s/master_port = \(10888\)/master_port = $_answer/g" $2/cluster.ini
    fi

    color_print success 'cluster.ini创建完成！'
}

# Parameters:
#   $1: $repo_root_dir      ~/DSTServerManager
#   $2: cluster derictory   ~/Klei/worlds/???
#   $3: $shard_???_name     Main / Cave
#   $4: _is_main_shard      yes / no
function configure_server_ini() {
    if [[ ! -e $2/$3 ]]; then mkdir -p $2/$3; fi
    if [[ $4 == 'yes' ]]; then 
        declare -r _default_port=11000
        declare -r _template_file=$1/templates/main_server.ini
    else
        declare -r _default_port=11001
        declare -r _template_file=$1/templates/cave_server.ini
    fi

    declare _answer
    echo ''
    color_print info "开始创建$3/server.ini"
    read_line _answer 36 "请输入$3世界端口(默认值$_default_port, 范围2000~65535): "
    if [[ ${#_answer} == 0 ]]; then _answer=$_default_port; fi
    sed "s/server_port = \($_default_port\)/server_port = $_answer/g" $_template_file > $2/$3/server.ini
    color_print warn "$3世界将使用端口$_answer, 请确保防火墙和安全组设置里打开了端口$_answer"
    color_print success "$3/server.ini创建完成！" -n; count_down 3 dot
}

# Parameters:
#   $1: $repo_root_dir      ~/DSTServerManager
#   $2: cluster dir         ~/Klei/worlds/cluster_name
#   $3: $shard_???_name     Main / Cave
#   $4: _is_main            yes / no
function create_cluster_in_multi_server() {
    # cluster.ini
    configure_cluster_ini $1 $2 'yes' $4

    # server.ini
    configure_server_ini $1 $2 $3 $4

    # leveldataoverride.lua
    #echo ''; color_print info "开始配置$5/$6世界的设置..."
    #if [[ $7 == 0 ]]; then
    #    configure_level_setting $1/templates/main_worldgenoverride.lua $3/$4/$5/$6/worldgenoverride.lua
    #else
    #    configure_level_setting $1/templates/cave_worldgenoverride.lua $3/$4/$5/$6/worldgenoverride.lua
    #fi
    if [[ $4 == 'yes' ]]; then
        lua -e "print('使用lua来配置主世界worldgenoverride.lua')"
    else
        lua -e "print('使用lua来配置洞穴worldgenoverride.lua')"
    fi
}

# Parameters:
#   $1: $repo_root_dir      ~/DSTServerManager
#   $2: cluster dir         ~/Klei/worlds/cluster_name
#   $3: $shard_???_name     Main
#   $4: $shard_???_name     Cave
function create_cluster_in_single_server() {
    # cluster.ini
    configure_cluster_ini $1 $2 'no' 'yes'
    
    # server.ini
    configure_server_ini $1 $2 $3 'yes'
    configure_server_ini $1 $2 $4 'no'

    # leveldataoverride.lua
    #echo ''; color_print info '开始配置主世界的设置...'
    #configure_level_setting $1/templates/main_worldgenoverride.lua $3/$4/$5/$6/worldgenoverride.lua
    #echo ''; color_print info '开始配置洞穴的设置...'
    #configure_level_setting $1/templates/cave_worldgenoverride.lua $3/$4/$5/$7/worldgenoverride.lua
    lua -e "print('使用lua来配置主世界worldgenoverride.lua')"
    lua -e "print('使用lua来配置洞穴worldgenoverride.lua')"
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
    declare _use_multi_server='no'
    declare _is_main='no'

    yes_or_no _use_multi_server info '是否使用多个主机开服？'
    if [[ $_use_multi_server == 'yes' ]]; then
        exit 1
        yes_or_no _is_main info '本服务器上的世界，是否为主世界？'
    fi

    declare _new_cluster
    read_line _new_cluster info '请输入新存档的文件夹名字' warn '(这个名字不是显示在服务器列表的名字)'
    if generate_cluster_list_from_dir $3/$4 | grep -sq $_new_cluster; then
        color_print error '该名字已经存在！'
        return 0
    fi
    color_print 39 "存档文件夹名字: $_new_cluster"

    mkdir -p $3/$4/$_new_cluster
    declare _token
    get_token _token
    echo $_token > $3/$4/$_new_cluster/cluster_token.txt

    if [[ $_use_multi_server == 'yes' ]]; then
        if [[ $_is_main == 'yes' ]]; then
            create_cluster_in_multi_server $1 $3/$4/$_new_cluster $5 $_is_main
        else
            create_cluster_in_multi_server $1 $3/$4/$_new_cluster $6 $_is_main
        fi
    else
        create_cluster_in_single_server $1 $3/$4/$_new_cluster $5 $6
    fi

    color_print success "新的世界$_new_cluster创建完成～"
}

##############################################################################################

# Parameters:
#   $1: $repo_root_dir      ~/DSTServerManager
#   $2: $dst_root_dir       ~/Server
#   $3: $klei_root_dir      ~/Klei
#   $4: worlds derictory    worlds
#   $5: $shard_main_name    Main
#   $6: $shard_cave_name    Cave
function cluster_panel() {
    declare _action
    declare -r -a _action_list=('新建存档' '更改世界选项' '删除存档' '返回')
    # ToDo: 备份存档 还原存档 导入存档

    while true; do
        echo ''
        color_print 70 '>>>>>> 存档管理 <<<<<<'
        display_running_clusters

        color_print info '[退出或中断操作请直接按 Ctrl加C ]'
        select_one _action_list _action

        case $_action in
        '新建存档')
            create_cluster $1 $2 $3 $4 $5 $6
            ;;
        '删除存档')
            declare _cluster=''
            if ! select_cluster_from_dir _cluster $3/$4; then
                color_print warn '未找到任何存档！ ' -n; count_down 3 dot
                continue
            fi
            delete_cluster $3/$4 $_cluster
            ;;
        '返回')
            color_print info '即将返回主面板 ' -n; count_down 3
            return 0
            ;;
        *)
            color_print error "${_action}功能暂未写好" -n; count_down 3 dot
            ;;
        esac
    done
}
