#!/usr/bin/env bash

#################### ################### Repositories ################### ####################
# 作者: yechentide      贴吧@夜尘tide
# Github: https://github.com/yechentide/DSTServerManager
# Gitee:  https://gitee.com/yechentide/DSTServerManager
# 主要使用Github, 上传Gitee只是单纯为了方便国内VPS下载...
# 欢迎会 shellscript / lua 的伙伴来一起写开服脚本！
##############################################################################################

set -eu

# 这个脚本里将会读取其他的全部shell脚本, 所以以下全局常量/变量在其他shell脚本里可用
declare OS='MacOS'
declare -r SCRIPT_VERSION='v1.4.7.0'
declare -r ARCHITECTURE=$(getconf LONG_BIT)
declare -r REPO_ROOT_DIR="$HOME/DSTServerManager"
# DST服务端文件夹
declare -r DST_ROOT_DIR="$HOME/Server"
declare -r UGC_DIR="$DST_ROOT_DIR/ugc_mods"
declare -r V1_MOD_DIR="$DST_ROOT_DIR/mods"
declare -r V2_MOD_DIR="$UGC_DIR/content"
# 存档文件夹
declare -r KLEI_ROOT_DIR="$HOME/Klei"
declare -r WORLDS_DIR='worlds'
declare -r BACKUP_DIR="$KLEI_ROOT_DIR/backup"
declare -r IMPORT_DIR="$KLEI_ROOT_DIR/import"
# shard文件夹默认名字
declare -r MAIN_SHARD_NAME='Main'
declare -r FOREST_SHARD_NAME='Forest'
declare -r CAVE_SHARD_NAME='Cave'

declare -r REPO_URL_CN='https://gitee.com/yechentide/DSTServerManager'
declare -r REPO_URL_GITHUB='https://github.com/yechentide/DSTServerManager'

# 为了降低Bash版本需求, 设置2个全局变量来传递值
declare answer=''
declare -a array=()

##############################################################################################
# 一些常用的函数

#######################################
# 作用: 给输出上色
# 参数:
#   -n: 输出不改行
#   -p: 禁止输出[INFO]之类的前缀
#   $1: 颜色代码(0~255) or 特定的字符串
#   $2: 需要改颜色的字符串
# 输出:
#   带颜色的字符串
#######################################
function color_print() {
    OPTIND=0
    declare -r esc=$(printf "\033")    # 更改输出颜色用的前缀
    declare -r reset="${esc}[0m"       # 重置所有颜色，字体设定
    declare new_line='true'
    declare no_prefix='false'

    declare option
    while getopts :np option; do
        case $option in
            n)  new_line='false' ;;
            p)  no_prefix='true' ;;
            *)  echo 'error in function color_print'; exit 1; ;;
        esac
    done
    shift $((OPTIND - 1))

    if [[ $# == 0 ]] || [[ $# == 1 && ! -p /dev/stdin ]]; then
        echo "${esc}[1;38;5;9m[Error] 参数数量错误. 用法: color_print 颜色 字符串${esc}[m"
        exit 1;
    fi

    if [[ -p /dev/stdin ]]; then        # <-- make pipe work
        declare -r str=$(cat -)        # <-- make pipe work
    else
        declare -r str="$2"
    fi

    declare prefix=''
    declare color=''
    case $1 in
    'info')     # 蓝
        color=33; prefix='[INFO] '; ;;
    'warn')     # 黄
        color=190; prefix='[WARN] '; ;;
    'success')  # 绿
        color=46; prefix='[OK] '; ;;
    'error')    # 红
        color=196; prefix='[ERROR] '; ;;
    'tip')      # 橙
        color=215; prefix='[TIP] '; ;;
    'debug')
        color=141; prefix='[debug] '; ;;
    *)
        color=$1; ;;
    esac

    if [[ $no_prefix == 'true' ]]; then prefix=''; fi
    if [[ $new_line == 'true' ]]; then
        echo "${esc}[38;5;${color}m${prefix}${str}${reset}"
    else
        echo -n "${esc}[38;5;${color}m${prefix}${str}${reset}"
    fi
    OPTIND=0
}

# Parameters:
#######################################
# 作用: 包装color_print(), 为一行输出上多种颜色
# 参数:
#   -p: 上色模式。不指定时为模式1
#   $1: 主颜色
#   $2: 强调色
#   $3: message
#   .....
# 输出:
#   带颜色的字符串
#######################################
function accent_color_print() {
    OPTIND=0
    declare accent_pattern=1

    declare option
    while getopts :p: option; do
        case $option in
            p)  accent_pattern=$OPTARG ;;
            *)  echo 'error in function accent_color_print'; exit 1; ;;
        esac
    done
    shift $((OPTIND - 1))

    case $accent_pattern in
    1)      #   --- * ---
        color_print -n $1 "$3"; color_print -np $2 "$4"; color_print -p $1 "$5"
        ;;
    2)      #   --- * --- * ---
        color_print -n $1 "$3"; color_print -np $2 "$4"; color_print -np $1 "$5"; color_print -np $2 "$6"; color_print -p $1 "$7"
        ;;
    *)
        color_print error 'accent_color_print()参数错误:'
        color_print error "$@"
        exit 1
        ;;
    esac
    OPTIND=0
}

#######################################
# 作用: 倒计时(默认是数字)
# 参数:
#   -d: 输出 . 来倒计时
#   $1: 秒数
# 输出:
#   3 2 1 0  或者  ....
#######################################
function count_down() {
    OPTIND=0
    declare use_dot='false'
    declare option
    while getopts :d option; do
        case $option in
            d)  use_dot='true' ;;
            *)  echo 'error in function count_down'; exit 1; ;;
        esac
    done
    shift $((OPTIND - 1))

    declare i
    if [[ $use_dot == 'true' ]]; then
        for i in $(seq $1 -1 1); do
            color_print -n 102 '.'
            sleep 1
        done
        echo ''
    else
        for i in $(seq $1 -1 1); do
            echo -n "$i " | color_print -n 102
            sleep 1
        done
        color_print 102 '0'
    fi
    OPTIND=0
}

#######################################
# 作用: 输出和终端窗口一样长的分割线
# 参数:
#   $1: 充当分割线的1字节字符
# 输出:
#   ==============
#######################################
function print_divider() {
    if [[ $# == 0 ]]; then
        eval "printf '%.0s'= {1..$(tput cols)}"     # 输出: 和窗口一样长的======
    else
        eval "printf '%.0s'$1 {1..$((  $(tput cols) / ${#1}  ))}"
    fi
    echo ''
}

#######################################
# 作用: 对用户进行确认
# 参数:
#   $1: 颜色代码(0~255) or 特定的字符串
#   $2: 提示用户的信息
# 返回:
#   `yes` / `no`   储存在全局变量answer
#######################################
function yes_or_no() {
    answer=''
    PS3='请输入选项数字> '
    while true; do
        color_print $1 "$2"
        select answer in yes no; do break; done
        if [[ ${#answer} == 0 ]]; then
            color_print error '请输入正确的数字！'
            continue
        fi
        return 0
    done
}

#######################################
# 作用: 多选一
# 参数:
#   $1: 颜色代码(0~255) or 特定的字符串
#   $2: 提示用户的信息
# 返回:
#   用户选择的   储存在全局变量answer
#######################################
function select_one() {
    answer=''
    PS3='请输入选项数字> '
    color_print $1 "$2"
    while true; do
        select answer in ${array[@]}; do break; done
        if [[ ${#answer} == 0 ]]; then
            color_print error '请输入正确的数字！'
            continue
        fi
        return 0
    done
}

#######################################
# 作用: 获得该脚本的绝对路径
# 输出:
#   DSTManager.sh的绝对路径
#######################################
function get_current_script_dir() {
    declare -r current_path=$(pwd)
    declare -r current_script_dir=$(cd $(dirname $0); pwd)
    cd $current_path
    echo $current_script_dir
}

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
        color_print error '出于安全方面考虑, 请勿使用root用户执行本脚本！'
        color_print tip '请使用sudo权限的用户执行本脚本'
        color_print tip '推荐把脚本上传到 /home/用户名 文件夹里面'
        exit 1
    fi
}

#######################################
# 作用: 确认用户是否有sudo权限
# 返回:
#   `yes` / `no`   储存在全局变量answer
#######################################
function check_user_is_sudoer() {
    declare sudoer_group=''
    if [[ $OS == 'Ubuntu' ]]; then sudoer_group='sudo'; fi
    if [[ $OS == 'CentOS' ]]; then sudoer_group='wheel'; fi
    if groups | grep -sqv $sudoer_group; then
        color_print warn "当前用户$(whoami)没有sudo权限, 可能无法下载依赖。"
        color_print warn '接下来将会列出所需依赖包, 如果不确定是否已安装, 请终止脚本！'
        color_print -n warn "有需要的话请联系管理员获取sudo权限, 或者帮忙下载依赖！ "; count_down -d 3
        answer='no'
    else
        answer='yes'
    fi
}

function check_script_position() {
    # 检测脚本位置
    if get_current_script_dir | grep -sq ^/root; then
        echo "当前用户: $(whoami)"
        echo "检测到该脚本位于root用户的家目录之下: $current_script_dir"
        echo '该脚本将会被删除'
        echo "脚本仓库将会安装到当前用户$(whoami)的家目录$HOME"
        echo "新的脚本将会位于$HOME/DSTManager.sh, 启动脚本请执行该文件"
        rm $0
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

    color_print -n info "准备下载脚本仓库至$REPO_ROOT_DIR "; count_down -d 3

    yes_or_no info '请问这个主机是否位于国内？'
    if [[ $answer == 'yes' ]]; then
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
    sleep 3
    exit 0
}

#######################################
# 作用: 检测依赖包是否已经安装
# 参数:
#   $1: 依赖包名字
# 输出:
#   'yes' / ''
#######################################
function is_package_installed() {
    if [[ $OS == 'Ubuntu' ]]; then
        # https://news.mynavi.jp/techplus/article/20190222-775519/
        if dpkg-query -l | awk '{print $2}' | grep -sq $1; then echo 'yes'; fi
    elif [[ $OS == 'CentOS' ]]; then
        if yum list installed | grep -sq $1; then echo 'yes'; fi
    fi
}

#######################################
# 作用: 获得所需依赖包的列表
# 返回:
#   所需依赖包数组   保存在全局变量array
#######################################
function get_dependencies() {
    array=()
    if [[ $OS == 'Ubuntu' ]]; then
        # 可能不需要的: lib32stdc++6 libcurl4-gnutls-dev:i386 libsdl2-2.0-0:i386
        array=(lib32gcc1 lua5.3 tmux wget git curl)
        # 32位: libgcc1 libstdc++6 libcurl4-gnutls-dev lua5.3 tmux wget git
    elif [[ $OS == 'CentOS' ]]; then
        # 可能不需要的:glibc.i686
        array=(libstdc++ lua tmux wget git which)
        # 32位: glibc libstdc++ glibc.i686 libcurl.so.4 libstdc++.so.6 tmux wget git
    fi
}

function install_dependencies() {
    check_user_is_sudoer
    declare -r is_sudoer=$answer
    get_dependencies
    declare -a requires=${array[@]}
    declare manager=''
    if [[ $OS == 'Ubuntu' ]]; then manager='apt'; fi
    if [[ $OS == 'CentOS' ]]; then manager='yum'; fi

    echo ''
    color_print info '需要下载或更新的软件: '
    echo "${requires[@]}"

    if [[ $is_sudoer == 'no' ]]; then
        color_print warn '以上软件是否已安装？没有安装的话请联系该服务器的管理员...'
        yes_or_no warn '是否已安装？'
        if [[ $answer == 'yes' ]]; then return 0; fi

        color_print error '无权限下载安装必须软件，终止运行脚本。请联系服务器管理员解决。'
        exit 1
    fi

    yes_or_no warn '是否要开始安装依赖？'
    if [[ $answer == 'no' ]]; then
        color_print error '终止安装依赖包, 结束脚本'
        exit 1
    fi

    color_print -n info '即将以管理员权限下载更新软件，可能会要求输入当前用户的密码 '; count_down 3

    if [[ $OS == 'Ubuntu' ]]; then
        sudo apt update && sudo apt upgrade -y
    elif [[ $OS == 'CentOS' ]]; then
        sudo yum update -y
    fi

    declare package
    for package in ${requires[@]}; do
        eval "sudo $manager install -y $package"
    done

    if [[ $OS == 'CentOS' ]] && [[ ! -e /usr/lib64/libcurl-gnutls.so.4 ]]; then
        # To fix: libcurl-gnutls.so.4: cannot open shared object file: No such file or directory
        sudo ln -s /usr/lib64/libcurl.so.4 /usr/lib64/libcurl-gnutls.so.4
    fi

    declare flag=1
    for package in ${requires[@]}; do
        if [[ $(is_package_installed $package) == 'yes' ]]; then
            color_print success "依赖包$package"
        else
            color_print error "依赖包$package"
            flag=0
        fi
    done
    if [[ $flag == 0 ]]; then color_print error '依赖包安装失败'; exit 1; fi
}

function install_steamcmd() {
    # https://developer.valvesoftware.com/wiki/SteamCMD#Linux
    if [[ ! -e ~/Steam ]]; then mkdir ~/Steam; fi
    if [[ -e ~/Steam/steamcmd.sh ]]; then
        color_print success 'steamcmd.sh已存在～'
        return 0
    fi

    echo ''
    color_print -n warn '未在~/Steam 发现steamcmd.sh，开始下载'; count_down -d 3
    # 该用哪个网站？
    # wget https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz
    # wget http://media.steampowered.com/installer/steamcmd_linux.tar.gz
    wget --output-document ~/Steam/steamcmd_linux.tar.gz 'https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz' && tar -xvzf ~/Steam/steamcmd_linux.tar.gz --directory ~/Steam

    if [[ $? ]]; then
        color_print success 'steamcmd.sh脚本下载完成！'
        rm -f ~/Steam/steamcmd_linux.tar.gz > /dev/null 2>&1
    else
        color_print error '似乎出现了什么错误...请联系作者修复'
        exit 1
    fi
}

function install_dst() {
    if [[ -e $DST_ROOT_DIR/bin64/dontstarve_dedicated_server_nullrenderer_x64 ]]; then
        color_print success '饥荒服务端已经下载好啦～'
        return 0
    fi

    echo ''
    color_print warn "路径$DST_ROOT_DIR 未找到饥荒服务端，即将开始下载..."
    color_print -n info '根据网络状况，下载可能会很耗时间，下载完成为止请勿息屏 '; count_down 3
    if [[ -e $DST_ROOT_DIR ]]; then rm -rf $DST_ROOT_DIR/* > /dev/null 2>&1; fi
    ~/Steam/steamcmd.sh +force_install_dir $DST_ROOT_DIR +login anonymous +app_update 343050 validate +quit
    # Error: /Steam/linux32/steamcmd: No such file or directory
    # Fix: install lib32gcc1
    if [[ $? ]]; then
        color_print success '饥荒服务端下载安装完成!'
        color_print info '途中可能会出现Failed to init SDL priority manager: SDL not found警告'
        color_print info '不用担心, 这个不影响下载/更新DST'
        color_print -n info '虽然可以解决, 但这需要下载一堆依赖包, 有可能会对其他运行中的服务造成影响, 所以无视它吧～ '; count_down -d 6
    else
        color_print error '似乎出现了什么错误...'
        yes_or_no info '重新下载？'
        if [[ $answer == 'yes' ]]; then
            rm -rf $DST_ROOT_DIR > /dev/null 2>&1
            install_dst
        fi
    fi
}

function add_alias() {
    declare source_file_path="$HOME/.bashrc"
    if echo $SHELL | grep -sq zsh; then
        source_file_path="$HOME/.zshrc"
    fi
    if [[ ! -e $source_file_path ]]; then touch $source_file_path; fi

    if ! cat $source_file_path | grep -sq "^alias dst="; then
        echo "alias dst='~/DSTServerManager/DSTManager.sh'" >> $source_file_path
        echo '' >> $source_file_path
    fi
    # source ~/.bashrc  --> 好像会导致报错  /etc/bashrc: line 12: PS1: unbound variable
}

function check_lua() {
    if which lua > /dev/null 2>&1; then return 0; fi

    if [[ $OS == 'Ubuntu' && ! -e /usr/bin/lua ]]; then
        if [[ -e /usr/bin/lua5.3 ]]; then
            sudo ln -s /usr/bin/lua5.3 /usr/bin/lua
        elif [[ -e /usr/bin/lua5.2 ]]; then
            sudo ln -s /usr/bin/lua5.2 /usr/bin/lua
        elif [[ -e /usr/bin/lua5.1 ]]; then
            sudo ln -s /usr/bin/lua5.1 /usr/bin/lua
        else
            color_print -n error '未能找到Lua命令 '; count_down -d 3
            exit 1
        fi
        color_print -n info '添加新的symbolic link /usr/bin/lua '; count_down -d 3
        return 0
    fi
    color_print -n error '未能找到Lua命令 '; count_down -d 3
    exit 1
}

function process_old_dot_file() {
    if [[ -e $REPO_ROOT_DIR/.skip_requirements_check ]]; then
        mv $REPO_ROOT_DIR/.skip_requirements_check $REPO_ROOT_DIR/.cache/.skip_requirements_check
    fi
    if [[ -e $REPO_ROOT_DIR/.need_update ]]; then
        mv $REPO_ROOT_DIR/.need_update $REPO_ROOT_DIR/.cache/.need_update
    fi
}

function make_directories() {
    mkdir -p $KLEI_ROOT_DIR/$WORLDS_DIR
    mkdir -p $BACKUP_DIR
    mkdir -p $IMPORT_DIR
    mkdir -p $V1_MOD_DIR
    mkdir -p $V2_MOD_DIR
    mkdir -p $REPO_ROOT_DIR/.cache/modinfo
}

function check_environment() {
    check_os
    if [[ $ARCHITECTURE == 32 ]]; then color_print error '暂不支持32位系统'; exit 1; fi
    check_user_is_root
    check_script_position

    clone_repo
    make_directories
    process_old_dot_file
    if [[ ! -e $REPO_ROOT_DIR/.cache/.skip_requirements_check ]]; then
        add_alias
        install_dependencies
        color_print -n info '输入source ~/.bashrc 或者重新登录后, 即可使用dst来执行脚本～'; count_down -d 3
        check_lua
        touch $REPO_ROOT_DIR/.cache/.skip_requirements_check
    fi

    install_steamcmd
    install_dst

    color_print info '即将跳转到主面板'
    sleep 1
}

##############################################################################################
for answer in $(ls $REPO_ROOT_DIR/scripts/*.sh); do source $answer; done

function check_script_update() {
    tmux new -d -s 'check_script_update'
    tmux send-keys -t 'check_script_update' "if git -C $REPO_ROOT_DIR remote show origin | grep -s 'main pushes' | grep -sq 'out of date'; then touch $REPO_ROOT_DIR/.cache/.need_update; fi; tmux kill-session" ENTER
}

function update_repo() {
    color_print info '开始更新脚本仓库...'
    if [[ -e $REPO_ROOT_DIR/.need_update ]]; then
        rm $REPO_ROOT_DIR/.need_update
    fi
    git -C $REPO_ROOT_DIR checkout .
    git -C $REPO_ROOT_DIR pull
    if [[ $? == 1 ]]; then
        color_print error '脚本仓库更新失败, 请检查git命令是否可用, 也有可能远程仓库目前无法访问'
        color_print error "当前的远程仓库URL: $(git remote -v | awk '{print $2}' | uniq)"
        return
    fi
    color_print success '脚本仓库更新完毕!请重新执行脚本~'
    exit 0
}

function main_panel_header() {
    print_divider '=' | color_print 208

    color_print 208 " DST Dedicated Server Manager $SCRIPT_VERSION"
    color_print 22  ' Github仓库: https://github.com/yechentide/DSTServerManager'
    color_print 22  ' Gitee仓库: https://gitee.com/yechentide/DSTServerManager'
    color_print 22  ' 全部代码上传到以上仓库里了, 有兴趣的伙伴可以来一起改善功能！'
    print_divider '-' | color_print 208

    color_print -n info '最近更新: '
    git -C $REPO_ROOT_DIR log --oneline | head -n 3 | sed -e 's/^[0-9a-z]* //g' | sed -z -e 's/\n/;    /g'
    echo ''

    color_print tip '如果服务器列表里不显示服务器, 请检查端口和防火墙&云服的安全组设置!'
    color_print tip '如果你启动游戏时看到有更新的话, 服务端这边也需要更新! 服务端管理界面可以更新服务端。'
    print_divider '-' | color_print 208

    if [[ -e $REPO_ROOT_DIR/.need_update ]]; then
        color_print info '～～～检测到脚本有新版本～～～'
        print_divider '-' | color_print 208
    fi
}

##############################################################################################

function display_running_clusters() {
    declare -a running_cluster_list=$(generate_list_from_tmux -s | tr '\n' ' ')
    color_print 30 "运行中的世界 ==> $running_cluster_list"
}

function main_panel() {
    check_script_update
    declare -r -a action_list=('服务端管理' '存档管理' 'Mod管理' '更新脚本' '退出')

    while true; do
        clear
        main_panel_header
        echo ''
        color_print 208 '>>>>>> >>>>>> 主面板 <<<<<< <<<<<<'
        display_running_clusters
        array=()
        answer=''

        color_print info '[退出或中断操作请直接按 Ctrl加C ]'
        array=${action_list[@]}; select_one info '请从下面选一个'
        declare action=$answer

        case $action in
        '服务端管理')
            server_panel
            ;;
        '存档管理')
            cluster_panel
            ;;
        'Mod管理')
            mod_panel
            ;;
        '更新脚本')
            update_repo
            ;;
        '退出')
            color_print info '感谢你的使用 ✧٩(ˊωˋ*)و✧'
            exit 0
            ;;
        *)
            color_print -n error "${action}功能暂未写好"; count_down -d 3
            ;;
        esac
    done
}

clear
check_environment
main_panel
