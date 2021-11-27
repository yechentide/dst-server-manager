function generate_cluster() {
    echo '创建新存档功能还未完成，请手动创建...'; exit 1
    # $1 = $CLUSTER_DIR
    echo '开始创建新的世界...'
    if [[ ! -e $CLUSTER_DIR ]]; then mkdir -p $CLUSTER_DIR; fi
    if [[ ! -e $CLUSTER_DIR/$DEFAULT_SHARD_MAIN ]]; then mkdir -p $CLUSTER_DIR/$DEFAULT_SHARD_MAIN; fi
    if [[ ! -e $CLUSTER_DIR/$DEFAULT_SHARD_CAVE ]]; then mkdir -p $CLUSTER_DIR/$DEFAULT_SHARD_CAVE; fi
    # token
    read -p "请输入token: " TOKEN
    echo $TOKEN >> $CLUSTER_DIR/cluster_token.txt
    # cluster.ini, server.ini
    configure_cluster_setting
    # leveldataoverride.lua
    configure_level_setting ./templates/cave_worldgenoverride.lua $CLUSTER_DIR/$DEFAULT_SHARD_MAIN/worldgenoverride.lua
    configure_level_setting ./templates/main_worldgenoverride.lua $CLUSTER_DIR/$DEFAULT_SHARD_CAVE/worldgenoverride.lua
    # mods
    #configureMods
}
function configure_cluster_setting() {
    cp templates/cluster.ini $CLUSTER_DIR/cluster.ini

    read -p "请输入服务器名字(将会显示在服务器列表): " CLUSTER_DISPLAY_NAME
    sed -e -i "s/cluster_name = \(鸽子们的摸鱼日常\)/cluster_name = $CLUSTER_DISPLAY_NAME/g" $CLUSTER_DIR/cluster.ini

    read -p "请输入服务器介绍(将会显示在服务器列表): " CLUSTER_DESCRIPTION
    sed -e -i "s/cluster_description = \(咕咕咕！\)/cluster_description = $CLUSTER_DESCRIPTION/g" $CLUSTER_DIR/cluster.ini

    read -p "请输入服务器密码(不设密码请空着): " CLUSTER_PASSWORD
    sed -e -i "s/cluster_password = \(password\)/cluster_password = $CLUSTER_PASSWORD/g" $CLUSTER_DIR/cluster.ini

    # social 休闲 cooperative 合作 competitive 竞赛 madness 疯狂
    read -p "请输入服务器风格(默认cooperative, 其他选项: competitive social madness): " CLUSTER_INTENTION
    sed -e -i "s/cluster_intention = \(cooperative\)/cluster_intention = $CLUSTER_INTENTION/g" $CLUSTER_DIR/cluster.ini

    # endless 无尽 survival 生存 wilderness 荒野 lavaarena 熔炉 quagmire 暴食
    read -p "请输入游戏模式(默认survival, 其他选项:endless wilderness): " GAME_MODE
    sed -e -i "s/game_mode = \(survival\)/game_mode = $GAME_MODE/g" $CLUSTER_DIR/cluster.ini

    read -p "请输入最大玩家人数(默认6): " MAX_PLAYERS
    sed -e -i "s/max_players = \(6\)/max_players = $MAX_PLAYERS/g" $CLUSTER_DIR/cluster.ini

    read -p "是否开启pvp(默认false, 其他选项true): " PVP
    sed -e -i "s/pvp = \(false\)/pvp = $PVP/g" $CLUSTER_DIR/cluster.ini

    read -p "开启无人暂停(默认true, 其他选项false): " PAUSE_WHEN_EMPTY
    sed -e -i "s/pause_when_empty = \(true\)/pause_when_empty = $PAUSE_WHEN_EMPTY/g" $CLUSTER_DIR/cluster.ini

    read -p "开启投票(true, 其他选项false): " VOTE_ENABLED
    sed -e -i "s/vote_enabled = \(true\)/vote_enabled = $VOTE_ENABLED/g" $CLUSTER_DIR/cluster.ini

    read -p "最大存档快照数(默认6, 可以用来回档): " MAX_SNAPSHOTS
    sed -e -i "s/max_snapshots = \(6\)/max_snapshots = $MAX_SNAPSHOTS/g" $CLUSTER_DIR/cluster.ini

    # generate Main/server.ini
    read -p "请输入主世界端口(空着直接按回车键，即为使用默认值11000): " MAIN_PORT
    sed -e "s/server_port = \(11000\)/server_port = $MAIN_PORT/g" templates/main_server.ini > $CLUSTER_DIR/$DEFAULT_SHARD_MAIN/server.ini

    # generate Cave/server.ini
    read -p "请输入洞穴的端口(空着直接按回车键，即为使用默认值11001): " CAVE_PORT
    sed -e "s/server_port = \(11001\)/server_port = $CAVE_PORT/g" templates/cave_server.ini > $CLUSTER_DIR/$DEFAULT_SHARD_CAVE/server.ini
}
function configure_level_setting() {
    # INPUT_FILE='./test/temp.lua'  --> $1
    # OUTPUT_FILE='./test/new.lua'  --> $2
    old_ifs=$IFS; IFS=''
    skip='false'

    if [[ -e $2 ]]; then rm $2; echo '配置文件已存在，执行删除操作...'; sleep 3; fi

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
            echo ''; echo '';
            echo '========== ========== ========== ========== ========== =========='
            echo ${LINE:7}
        fi

        if [[ ${LINE:0:8} == '        ' ]]; then
            NAME_CH=$(echo $LINE | awk '{print $3}' | awk -F ':' '{print $1}')
            NAME_EN=$(echo $LINE | awk '{print $1}' | awk -F '=' '{print $1}')
            DEFAULT_VALUE=$(echo $LINE | awk '{print $1}' | awk -F '=' '{print $2}' | awk -F '"' '{print $2}')
            OPTIONS=$(echo $LINE | awk '{print $4}' | sed -e "s/,/  /g")

            echo ''
            echo '---------- ---------- ----------'
            echo "${NAME_CH}(${NAME_EN})   默认值: ${DEFAULT_VALUE}"
            echo "可选项目: ${OPTIONS}"

            while true; do
                read -p '> ' ANS
                if [[ ${#ANS} == 0 ]]; then
                    echo "使用默认值: $DEFAULT_VALUE"
                    echo $LINE >> $2
                    break
                fi

                if echo $OPTIONS | grep $ANS > /dev/null 2>&1; then
                    echo "当前设定: $ANS"
                    echo $LINE | sed -e "s/$DEFAULT_VALUE/$ANS/" >> $2
                    break
                fi

                echo "输入错误: $ANS, 请检查你的拼写并输入正确的选项"
            done
        else
            echo $LINE >> $2
        fi
    done 6< $1
    IFS=$old_ifs
    echo "配置完成，可以修改 ${2} 来手动更改配置"
}