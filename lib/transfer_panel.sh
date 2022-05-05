#######################################
# 作用:
#   移动文件夹到本脚本指定位置,
#   并在原来位置创建 symbolic link
# 参数:
#   $1: old_steamcmd_path
#   $2: old_steam_path
#   $3: old_server_path
#   $4: old_klei_path
#   $5: old_world_dir
#######################################
function move_dir_add_symbolic_link() {
    if [[ -e $1 ]]; then color_print warn "未找到steamcmd文件夹"; exit 1; fi
    if [[ -e $2 ]]; then color_print warn "未找到steam文件夹"; exit 1; fi
    if [[ -e $3 ]]; then color_print warn "未找到饥荒联机版的服务端文件夹"; exit 1; fi
    if [[ -e $4 ]]; then color_print warn "未找到存档文件夹"; exit 1; fi

    # 饥荒服务端
    if [[ ! -e "$DST_ROOT_DIR" ]]; then
        mv "$3" "$DST_ROOT_DIR"
        ln -s "$DST_ROOT_DIR" "$3"
    else
        rm -rf "$3"
    fi

    # 存档
    #mv "$KLEI_ROOT_DIR" "/tmp/old_klei_$(date '+%s')"
    #if [[ "$KLEI_ROOT_DIR" != "$4" ]] && [[ -e "$KLEI_ROOT_DIR" ]]; then
    #    mv "$KLEI_ROOT_DIR" "${KLEI_ROOT_DIR}_old"
    #fi

    if [[ "$KLEI_ROOT_DIR" == "$4" ]] && [[ "$WORLDS_DIR" != "$5" ]]; then
        mv "$KLEI_ROOT_DIR/$5" "$KLEI_ROOT_DIR/$WORLDS_DIR"
        ln -s "$KLEI_ROOT_DIR/$WORLDS_DIR" "$KLEI_ROOT_DIR/$5"
    elif [[ "$KLEI_ROOT_DIR" != "$4" ]] && [[ "$WORLDS_DIR" == "$5" ]]; then
        mv "$4" "$KLEI_ROOT_DIR"
        ln -s "$KLEI_ROOT_DIR" "$4"
    elif [[ "$KLEI_ROOT_DIR" != "$4" ]] && [[ "$WORLDS_DIR" != "$5" ]]; then
        mv "$4/$5" "$4/$WORLDS_DIR"
        mv "$4" "$KLEI_ROOT_DIR"
        ln -s "$KLEI_ROOT_DIR" "$4"
        ln -s "$KLEI_ROOT_DIR/$WORLDS_DIR" "$KLEI_ROOT_DIR/$5"
    fi

    # Steam本体
    if [[ ! -e "$HOME/Steam" ]]; then
        mv "$2" "$HOME/Steam"
        ln -s "$HOME/Steam" "$2"
    else
        rm -rf "$2"
    fi

    # SteamCMD
    if [[ ! -e "$HOME/Steam/steamcmd.sh" ]]; then
        mv "$1/*" "$HOME/Steam" && rm -rf "$1"
        ln -s "$HOME/Steam" "$1"
    else
        rm -rf "$1"
    fi
}


#######################################
# 作用: go.sh --> DSTManager.sh
# 参数:
#   $1: will_need_sudo      'yes' / 'no'
#######################################
function transfer_from_go() {
    # go.sh
    # 欲醉无由 2016.11.12
    declare old_home=$HOME
    if [[ $1 == 'yes' ]]; then old_home='/root'; fi
    declare -r old_steamcmd_path="$old_home/steamcmd"
    declare -r old_steam_path="$old_home/Steam"
    declare -r old_server_path="$old_home/Steam/steamapps/common/Don't Starve Together Dedicated Server"
    declare -r old_klei_path="$old_home/.klei"
    declare -r old_world_dir='DoNotStarveTogether'

    move_dir_add_symbolic_link "$old_steamcmd_path" "$old_steam_path" "$old_server_path" "$old_klei_path" "$old_world_dir"
}

#######################################
# 作用: dstserver.sh --> DSTManager.sh
# 参数:
#   $1: will_need_sudo      'yes' / 'no'
#######################################
function transfer_from_dstserver() {
    # dstserver.sh
    # Ariwori(i@wqlin.com)
    # 发布于: https://blog.wqlin.com/archives/157.html
    # 于2021年12月15日起停止功能更新
    declare old_home=$HOME
    if [[ $1 == 'yes' ]]; then old_home='/root'; fi
    declare -r old_steamcmd_path="$old_home/DST/steamcmd"
    declare -r old_steam_path="$old_home/Steam"
    declare -r old_server_path="$old_home/DST/DSTServer"
    declare -r old_klei_path="$old_home/DST/Klei"
    declare -r old_world_dir='DoNotStarveTogether'

    move_dir_add_symbolic_link "$old_steamcmd_path" "$old_steam_path" "$old_server_path" "$old_klei_path" "$old_world_dir"
}

function transfer_panel() {
    declare will_need_sudo='no'
    check_user_is_sudoer
    declare -r has_sudo_perm=$answer
    declare -r error_exit_msg="请参考${REPO_ROOT_DIR}/docs/结构.md文件, 手动移动文件夹"

    color_print warn '本功能未经测试!如果担心出问题的话, 请选择 "返回"'
    color_print info '在这里本脚本会移动旧脚本管理的文件夹, 以使文件夹位置符合本脚本设置'
    color_print -n info '如果你没在列表里看到自己用过的脚本名字, 请选择 "返回"'; count_down 3

    confirm info '请问你是以root用户执行之前的脚本的吗?'
    if [[ $(cat $ANSWER_PATH) == 'yes' ]]; then
        if [[ $has_sudo_perm == 'no' ]]; then
            color_print warn "当前用户$(whoami)没有sudo权限, 无法从/root文件夹里面转移文件, ${error_exit_msg}"
            color_print info '即将返回主面板'
            sleep 1
            return 0
        fi
        will_need_sudo='yes'
    fi
    
    declare -a array=()
    declare -r -a script_list=('欲醉无由写的go.sh' 'Ariwori写的dstserver.sh')
    while true; do
        echo ''
        color_print 70 '>>>>>> 脚本迁移 <<<<<<'
        display_running_clusters
        color_print info '[退出或中断操作请直接按 Ctrl加C ]'

        declare script=''
        if [[ -e $ARRAY_PATH ]]; then rm $ARRAY_PATH; fi
        for script in ${script_list[@]}; do echo $script >> $ARRAY_PATH; done
        selector -cq info '请选择你之前使用的脚本'
        script=$(cat $ANSWER_PATH)

        case $script in
        '欲醉无由写的go.sh')
            transfer_from_go $will_need_sudo
            ;;
        'Ariwori写的dstserver.sh')
            transfer_from_dstserver $will_need_sudo
            ;;
        '返回')
            color_print info '即将返回主面板'
            sleep 1
            return 0
            ;;
        *)
            color_print -n error "暂不支持自动从${script}迁移, ${error_exit_msg}"; count_down 3
            ;;
        esac
    done
}
