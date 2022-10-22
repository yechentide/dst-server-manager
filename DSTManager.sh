#!/usr/bin/env bash
set -eu

#################### ################### Repositories ################### ####################
# 作者: yechentide      贴吧@夜尘tide
# Github: https://github.com/yechentide/DSTServerManager
# Gitee:  https://gitee.com/yechentide/DSTServerManager
# 主要使用Github, 上传Gitee只是单纯为了方便国内VPS下载...
# 欢迎会 shellscript / lua 的伙伴来一起写开服脚本！
##############################################################################################

# 这个脚本里将会读取其他的全部shell脚本, 所以以下全局常量/变量在其他shell脚本里可用
declare OS='MacOS'
declare -r SCRIPT_VERSION='v1.6.0'
declare -r ARCHITECTURE=$(getconf LONG_BIT)
declare -r REPO_ROOT_DIR="$HOME/DSTServerManager"
# DST服务端文件夹
declare -r DST_ROOT_DIR="$HOME/Server"
declare -r UGC_DIR="$DST_ROOT_DIR/ugc_mods"
declare -r V1_MOD_DIR="$DST_ROOT_DIR/mods"
declare -r V2_MOD_DIR="$UGC_DIR/content"
# 存档文件夹
declare -r KLEI_ROOT_DIR="$HOME/Klei"
declare -r WORLDS_DIR_NAME='worlds'
declare -r BACKUP_DIR="$KLEI_ROOT_DIR/backup"
declare -r IMPORT_DIR="$KLEI_ROOT_DIR/import"

# shard文件夹默认名字() ### 不强制命名
#declare -r MAIN_SHARD_NAME='Main'
#declare -r FOREST_SHARD_NAME='Forest'
#declare -r CAVE_SHARD_NAME='Cave'

##############################################################################################
# 以下变量请勿修改

# 仓库地址
declare -r REPO_URL_CN='https://gitee.com/yechentide/DSTServerManager'
declare -r REPO_URL_GITHUB='https://github.com/PNCommand/DSTServerManager'
# 用来传递值的文件位置
declare -r CACHE_DIR="$REPO_ROOT_DIR/.cache"
declare -r ARRAY_PATH="$CACHE_DIR/array"
declare -r ANSWER_PATH="$CACHE_DIR/answer"
# 可执行命令
export PATH="$REPO_ROOT_DIR/bin:$REPO_ROOT_DIR/bin/output:$REPO_ROOT_DIR/bin/interaction:$REPO_ROOT_DIR/bin/environment:$REPO_ROOT_DIR/bin/utils:$PATH"

##############################################################################################

function check_os() {
    if [[ ! $(uname) == 'Linux' ]]; then color_print error '本脚本目前仅支持Linux'; exit 1; fi

    if grep -sq '^NAME="Ubuntu' /etc/os-release; then
        OS='Ubuntu'
    elif grep -sq '^NAME="CentOS' /etc/os-release; then
        OS='CentOS'
    else
        color_print error '本脚本暂不支持此Linux系统：'
        cat /etc/os-release | grep ^NAME | color_print error
        cat /etc/os-release | grep ^VERSION= | color_print error
        color_print tip '你可以换个系统, 或者自己修改这个脚本, 或者联系作者(需求多的话才会添加支持)'
        exit 1
    fi
}

function check_user_is_root() {
    if echo $HOME | grep -sq ^/root; then
        color_print error '出于安全方面考虑, 最好不要使用root用户执行本脚本！'
        color_print tip '这里建议你使用 Ctrl 加 c 来终止脚本, 并使用sudo权限的用户执行本脚本(暂停10s来等你决定)'
        count_down -n 10
    fi
}

function clone_repo() {
    color_print info "检测脚本仓库, 目标路径: $REPO_ROOT_DIR"

    if [[ -e $REPO_ROOT_DIR ]]; then
        if [[ ! -e $REPO_ROOT_DIR/.git ]]; then
            color_print warn '脚本仓库可能已经损坏, 即将重新下载...'
            rm -rf $REPO_ROOT_DIR > /dev/null 2>&1
        else
            color_print success '脚本仓库已存在！无需下载～'
            return 0
        fi
    else
        color_print warn '未发现脚本仓库！'
    fi

    color_print -n info "准备下载脚本仓库至$REPO_ROOT_DIR "
    count_down -d 3

    confirm info '请问这个主机是否位于国内？'
    if [[ $(cat $ANSWER_PATH) == 'yes' ]]; then
        color_print info '远程仓库将使用gitee上的仓库'
        color_print warn 'gitee网站有时候会无法访问, 如果无法下载, 请隔一段时间重试'
        git clone $REPO_URL_CN $REPO_ROOT_DIR
    else
        color_print info '远程仓库将使用github上的仓库'
        git clone $REPO_URL_GITHUB $REPO_ROOT_DIR
    fi

    if [[ $? == 1 ]]; then
        color_print error '脚本仓库下载失败, 请检查git命令是否可用, 也有可能远程仓库目前无法访问'
        color_print error "当前的远程仓库URL: $(git remote -v | awk '{print $2}' | uniq)"
        rm -rf $REPO_ROOT_DIR > /dev/null 2>&1
        exit 1
    fi

    rm $0       # 删除被执行的脚本文件
    ln -s $REPO_ROOT_DIR/DSTManager.sh $HOME/DSTManager.sh

    echo ''
    color_print success '脚本仓库下载完成！请重新运行脚本。'
    color_print info '以后运行脚本请使用该命令： ~/DSTManager.sh'
    count_down 3
    exit 0
}

function manage_directories() {
    mkdir -p $KLEI_ROOT_DIR/$WORLDS_DIR_NAME
    mkdir -p $BACKUP_DIR
    mkdir -p $IMPORT_DIR
    mkdir -p $V1_MOD_DIR
    mkdir -p $V2_MOD_DIR
    mkdir -p $CACHE_DIR
    touch $ARRAY_PATH
    touch $ANSWER_PATH
    
    if [[ -e $REPO_ROOT_DIR/.cache/modinfo ]]; then rm -rf $REPO_ROOT_DIR/.cache/modinfo; fi
}

function check_environment() {
    check_os
    if [[ $ARCHITECTURE == 32 ]]; then color_print error '本脚本不支持32位系统'; exit 1; fi
    check_user_is_root
    clone_repo
    manage_directories

    if [[ ! -e $CACHE_DIR/.skip_requirements_check ]]; then
        # >>>>>> BUG <<<<<<
        # confirm info '你之前有在本机器/云服上使用别的脚本开服吗?'
        # if [[ $(cat $ANSWER_PATH) == 'yes' ]]; then
        #     color_print -n info '即将进入脚本迁移面板 '
        #     count_down -n 3
        #     transfer_panel
        # fi
        add_alias
        install_dependencies $OS
        color_print -n info '输入source ~/.bashrc 或者重新登录后, 即可使用dst来执行脚本～ '
        count_down -n 6
        check_lua $OS

        touch $CACHE_DIR/.skip_requirements_check
    fi

    install_steamcmd
    update_dst $DST_ROOT_DIR

    declare file=''
    for file in $(ls $REPO_ROOT_DIR/lib/*.sh); do source $file; done
    for file in $(ls $REPO_ROOT_DIR/lib/server/*.sh); do source $file; done
    for file in $(ls $REPO_ROOT_DIR/lib/cluster/*.sh); do source $file; done
    for file in $(ls $REPO_ROOT_DIR/lib/mod/*.sh); do source $file; done

    color_print info '即将跳转到主面板'
    sleep 1
}

##############################################################################################

function check_script_update() {
    tmux new -d -s 'check_script_update'
    tmux send-keys -t 'check_script_update' "if git -C $REPO_ROOT_DIR remote show origin | grep -s 'main pushes' | grep -sq 'out of date'; then touch $REPO_ROOT_DIR/.cache/.need_update; fi; tmux kill-session" ENTER
}

function main_panel_header() {
    print_divider '=' | color_print 208
    color_print 208 " DST Dedicated Server Manager $SCRIPT_VERSION"
    print_divider '-' | color_print 208

    color_print -n info '最近更新: '
    git -C $REPO_ROOT_DIR log --oneline | head -n 3 | sed -e 's/^[0-9a-z]* //g' | sed -z -e 's/\n/;    /g'
    echo ''

    color_print tip '服务器列表里搜索不到?   -->   检查端口和防火墙&云服的安全组设置!'
    color_print tip '启动游戏时看到有更新?   -->   在脚本的 "服务端管理界面" 更新服务端!'

    if [[ -e $CACHE_DIR/.need_update ]]; then
        print_divider '-' | color_print 208
        color_print info '～～～检测到脚本有新版本～～～'
    fi
    print_divider '=' | color_print 208
}

function display_running_clusters() {
    declare -a running_cluster_list=$(generate_server_list -s | tr '\n' ' ')
    color_print 30 "运行中的世界 ==> $running_cluster_list"
}

##############################################################################################

function main_panel() {
    check_script_update
    declare -r -a action_list=('启动' '控制台' '关闭' '服务端管理' '存档管理' 'Mod管理' '其他功能' '退出')

    while true; do
        clear
        main_panel_header
        echo ''
        color_print 208 '>>>>>> >>>>>> 主面板 <<<<<< <<<<<<'
        display_running_clusters
        color_print info '[退出或中断操作请直接按 Ctrl加C ]'

        declare action=''
        rm $ARRAY_PATH
        for action in ${action_list[@]}; do echo $action >> $ARRAY_PATH; done
        selector -q info '请从下面选一个'
        action=$(cat $ANSWER_PATH)

        case $action in
        '启动')
            start_server
            ;;
        '控制台')
            enter_console
            ;;
        '关闭')
            stop_server
            ;;
        '服务端管理')
            server_panel
            ;;
        '存档管理')
            cluster_panel
            ;;
        'Mod管理')
            mod_panel
            ;;
        '其他功能')
            other_panel
            ;;
        '退出')
            color_print info '感谢你的使用 ✧٩(ˊωˋ*)و✧'
            exit 0
            ;;
        *)
            color_print -n error "${action}功能暂未写好"
            count_down 3
            ;;
        esac
    done
}

clear
check_environment
main_panel
