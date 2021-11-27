source ~/DSTServerManager/utils/output.sh
source ~/DSTServerManager/scripts/setup_mod.sh

# Parameters:
#   $1: $DST_ROOT_DIR      ~/Server
#   $2: $DST_ROOT_DIR      ~/Klei
#   $3: worlds derictory   worlds
#   $4: $SHARD_MAIN        Main
#   $5: $SHARD_CAVE        Cave
function create_cluster() {
    color_print info '开始创建新的世界...'
    read -p '请输入新世界的文件夹名字(这个名字不是显示在服务器列表的名字)> ' new_cluster
    if ls -l $2/$3 | awk '$1 ~ /d/ {print $9 }' | grep "$new_cluster" > /dev/null 2>&1; then
        color_print error '该名字已经存在！'
        return 1
    fi

    if [[ ! -e $2/$3/$new_cluster/$4 ]]; then mkdir -p $2/$3/$new_cluster/$4; fi
    if [[ ! -e $2/$3/$new_cluster/$5 ]]; then mkdir -p $2/$3/$new_cluster/$5; fi

    # token
    while true; do
        read -p "请输入token: " token
        if [[ ${#token} == 0 ]]; then
            color_print error '你输入token了吗？？？'
            continue
        fi
        echo $token >> $2/$3/$new_cluster/cluster_token.txt
        break
    done

    # cluster.ini, server.ini
    configure_cluster_setting $2/$3/$new_cluster $4 $5
    # leveldataoverride.lua
    echo ''; color_print info '开始配置主世界的设置...'
    configure_level_setting ~/DSTServerManager/templates/main_worldgenoverride.lua $2/$3/$new_cluster/$4/worldgenoverride.lua
    echo ''; color_print info '开始配置洞穴的设置...'
    configure_level_setting ~/DSTServerManager/templates/cave_worldgenoverride.lua $2/$3/$new_cluster/$5/worldgenoverride.lua
    
    # mods
    PS3='马上添加mod嘛？请输入数字> '
    select answer in 添加mod 不了; do break; done
    if [[ $answer == '添加mod' ]]; then
        add_mods $1 $2/$3 $4 $5 $new_cluster
    fi

    color_print info '新的世界创建完成～'
}

# Parameters:
#   $1: cluster derictory   ~/Klei/worlds/???
#   $2: $SHARD_MAIN         Main
#   $3: $SHARD_CAVE         Cave
function configure_cluster_setting() {
    # generate cluster.ini
    echo ''; color_print info '开始创建cluster.ini'
    color_print info '空栏状态下回车，即可使用默认值'
    cp ~/DSTServerManager/templates/cluster.ini $1/cluster.ini

    read -p "请输入服务器名字(将会显示在服务器列表): " CLUSTER_DISPLAY_NAME
    sed -i "s/cluster_name = \(鸽子们的摸鱼日常\)/cluster_name = $CLUSTER_DISPLAY_NAME/g" $1/cluster.ini

    read -p "请输入服务器介绍(将会显示在服务器列表): " CLUSTER_DESCRIPTION
    sed -i "s/cluster_description = \(咕咕咕！\)/cluster_description = $CLUSTER_DESCRIPTION/g" $1/cluster.ini

    read -p "请输入服务器密码(不设密码请空着): " CLUSTER_PASSWORD
    sed -i "s/cluster_password = \(password\)/cluster_password = $CLUSTER_PASSWORD/g" $1/cluster.ini

    # social 休闲 cooperative 合作 competitive 竞赛 madness 疯狂
    read -p "请输入服务器风格(默认cooperative, 其他选项: competitive social madness): " CLUSTER_INTENTION
    sed -i "s/cluster_intention = \(cooperative\)/cluster_intention = $CLUSTER_INTENTION/g" $1/cluster.ini

    # endless 无尽 survival 生存 wilderness 荒野 lavaarena 熔炉 quagmire 暴食
    read -p "请输入游戏模式(默认survival, 其他选项:endless wilderness): " GAME_MODE
    sed -i "s/game_mode = \(survival\)/game_mode = $GAME_MODE/g" $1/cluster.ini

    read -p "请输入最大玩家人数(默认6): " MAX_PLAYERS
    sed -i "s/max_players = \(6\)/max_players = $MAX_PLAYERS/g" $1/cluster.ini

    read -p "是否开启pvp(默认false, 其他选项true): " PVP
    sed -i "s/pvp = \(false\)/pvp = $PVP/g" $1/cluster.ini

    read -p "开启无人暂停(默认true, 其他选项false): " PAUSE_WHEN_EMPTY
    sed -i "s/pause_when_empty = \(true\)/pause_when_empty = $PAUSE_WHEN_EMPTY/g" $1/cluster.ini

    read -p "开启投票(true, 其他选项false): " VOTE_ENABLED
    sed -i "s/vote_enabled = \(true\)/vote_enabled = $VOTE_ENABLED/g" $1/cluster.ini

    read -p "最大存档快照数(默认6, 可以用来回档): " MAX_SNAPSHOTS
    sed -i "s/max_snapshots = \(6\)/max_snapshots = $MAX_SNAPSHOTS/g" $1/cluster.ini

    color_print info 'cluster.ini创建完成！'

    # generate Main/server.ini
    echo ''; color_print info "开始创建$2/server.ini"
    read -p "请输入主世界端口(默认值11000, 范围2000~65535): " MAIN_PORT
    sed "s/server_port = \(11000\)/server_port = $MAIN_PORT/g" ~/DSTServerManager/templates/main_server.ini > $1/$2/server.ini
    color_print info "$2/server.ini创建完成！"

    # generate Cave/server.ini
    echo ''; color_print info "开始创建$3/server.ini"
    read -p "请输入洞穴的端口(默认值11000, 范围2000~65535): " CAVE_PORT
    sed "s/server_port = \(11001\)/server_port = $CAVE_PORT/g" ~/DSTServerManager/templates/cave_server.ini > $1/$3/server.ini
    color_print info "$3/server.ini创建完成！"
}

# Parameters:
#   $1: input template       ~/DSTServerManager/templates/???.lua
#   $2: output file          ~/Klei/worlds/???/Main/worldgenoverride
function configure_level_setting() {
    old_ifs=$IFS; IFS=''
    skip='false'

    if [[ -e $2 ]]; then rm $2; color_print info '配置文件已存在，执行删除操作...'; sleep 3; fi
    color_print info '空栏状态下回车，即可使用默认值'

    while read -u 6 LINE; do
        if [[ $skip == 'true' ]]; then
            echo $LINE >> $2
            continue
        fi
        if [[ ${LINE:0:8} == '    -->>' ]]; then
            echo $LINE >> $2
            skip='true'
            continue
        fi


        if [[ ${LINE:0:7} == '    -- ' ]]; then
            echo ''; echo '========== ========== ========== ========== ========== =========='
            echo ${LINE:7}
        fi

        if [[ ${LINE:0:8} == '        ' ]]; then
            NAME_CH=$(echo $LINE | awk '{print $3}' | awk -F ':' '{print $1}')
            NAME_EN=$(echo $LINE | awk '{print $1}' | awk -F '=' '{print $1}')
            DEFAULT_VALUE=$(echo $LINE | awk '{print $1}' | awk -F '=' '{print $2}' | awk -F '"' '{print $2}')
            OPTIONS=$(echo $LINE | awk '{print $4}' | sed -e "s/,/  /g")

            echo ''
            color_print 215 '---------- ---------- ----------'
            color_print 172 "${NAME_CH}(${NAME_EN})   默认值: ${DEFAULT_VALUE}"
            color_print 180 '可选项目: ' -n
            color_print 186 "${OPTIONS}"

            while true; do
                read -p '> ' ANS
                if [[ ${#ANS} == 0 ]]; then
                    color_print 39 "使用默认值: $DEFAULT_VALUE"
                    echo $LINE >> $2
                    break
                fi

                if echo $OPTIONS | grep $ANS > /dev/null 2>&1; then
                    color_print 39 "当前设定: $ANS"
                    echo $LINE | sed -e "s/$DEFAULT_VALUE/$ANS/" >> $2
                    break
                fi

                color_print error "输入错误: $ANS, 请检查你的拼写并输入正确的选项"
            done
        else
            echo $LINE >> $2
        fi
    done 6< $1
    IFS=$old_ifs
    color_print info "配置完成，可以修改 ${2} 来手动更改配置"
}
