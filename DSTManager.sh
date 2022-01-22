#!/usr/bin/env bash

#################### ################### Repositories ################### ####################
# 作者: yechentide      贴吧@夜尘tide
# Github: https://github.com/yechentide/DSTServerManager
# Gitee:  https://gitee.com/yechentide/DSTServerManager
# 主要使用Github, 上传Gitee只是单纯为了方便国内VPS下载...
# 欢迎会 shellscript / lua 的伙伴来一起写开服脚本！
##############################################################################################

set -eu

# 这个脚本里将会读取其他的全部shell脚本, 所以以下全局变量在其他shell脚本里可用
declare os='MacOS'
declare -r script_version='v1.4.0'
declare -r architecture=$(getconf LONG_BIT)
declare -r repo_root_dir="$HOME/DSTServerManager"
# DST服务端文件夹
declare -r dst_root_dir="$HOME/Server"
declare -r ugc_directory="$dst_root_dir/ugc_mods"
declare -r mod_dir_v1="$dst_root_dir/mods"
declare -r mod_dir_v2="$ugc_directory/content"
# 存档文件夹
declare -r klei_root_dir="$HOME/Klei"
declare -r worlds_dir='worlds'
declare -r backup_dir="$klei_root_dir/backup"
# shard文件夹默认名字
declare -r main_shard_name='Main'
declare -r overground_shard_name='Forest'
declare -r underground_shard_name='Cave'

declare -r repo_url_china='https://gitee.com/yechentide/DSTServerManager'
declare -r repo_url_global='https://github.com/yechentide/DSTServerManager'

# 为了降低Bash版本需求, 设置2个全局变量来传递值
declare answer=''
declare -a array=()

##############################################################################################
# 一些常用的函数

# References:
#   https://qiita.com/ko1nksm/items/095bdb8f0eca6d327233
#   https://qiita.com/dojineko/items/49aa30018bb721b0b4a9
#
# 16色
#   格式: \033[属性;前景色;背景色m
#   属性
#       0:reset, 1:粗体, 2:低輝度, 3:斜体, 4:下划线, 5:闪烁, 6:高速闪烁, 7:反転, 8:非表示, 9:取消线
#       21:二重下划线, 22:粗体・低輝度解除, 23:斜体解除, 24:下划线解除, 25:闪烁解除, 27:反転解除, 28:非表示解除, 29:取消线解除
#   前景色 - ()里是亮点的颜色
#       30(90)黒, 31(91)赤, 32(92)緑, 33(93)黄, 34(94)青, 35(95)紫, 36(96)水, 37(97)白, 38拡張色, 39標準色
#   背景色 - ()里是亮点的颜色
#       40(100)黒, 41(101)赤, 42(102)緑, 43(103)黄, 44(104)青, 45(105)紫, 46(106)水, 47(107)白, 48拡張色, 49標準色
#
# 256色
#   格式: \033[属性;前景色;背景色m
#       前景色 38;5;颜色代码
#       背景色 48;5;颜色代码
#   颜色范围
#       0-7： 标准色8色             （和 \033[30m - \033[37m 一样）
#       8-15： 亮色8色              （和 \033[90m - \033[97m 一样）
#       16-231： 各色（赤・緑・青） 6段階、6×6×6=216色
#       232-255： gray scale、24色
#
# 取消全部格式
#   格式: \033[m  或者  \033[0m
#
# Options: (option必须在普通参数前面)
#   -n: 添加这个选项的话, 将会使用echo的-n选项 = 输出不改行
#   -p: 添加这个选项的话, 将不会输出[INFO]之类的前缀
# Parameters:
#   $1: 颜色代码(0~255) or 特定的字符串
#   $2: 需要改颜色的字符串
function color_print() {
    OPTIND=0
    declare -r _esc=$(printf "\033")    # 更改输出颜色用的前缀
    declare -r _reset="${_esc}[0m"      # 重置所有颜色，字体设定
    declare _new_line='true'
    declare _no_prefix='false'

    declare _option
    while getopts :n _option; do
        case $_option in
            n)  _new_line='false' ;;
            p)  _no_prefix='true' ;;
            *)  echo 'error in function color_print'; exit 1; ;;
        esac
    done
    shift $((OPTIND - 1))

    if [[ $# == 0 ]] || [[ $# == 1 && ! -p /dev/stdin ]]; then
        echo "${_esc}[1;38;5;9m[Error] 参数数量错误. 用法: color_print 颜色 字符串${_esc}[m"
        exit 1;
    fi

    if [[ -p /dev/stdin ]]; then        # <-- make pipe work
        declare -r _str=$(cat -)        # <-- make pipe work
    else
        declare -r _str="$2"
    fi

    declare _prefix=''
    declare _color=''
    case $1 in
    'info')     # 蓝
        _color=33; _prefix='[INFO] '; ;;
    'warn')     # 黄
        _color=190; _prefix='[WARN] '; ;;
    'success')  # 绿
        _color=46; _prefix='[OK] '; ;;
    'error')    # 红
        _color=196; _prefix='[ERROR] '; ;;
    'tip')      # 橙
        _color=215; _prefix='[TIP] '; ;;
    'debug')
        _color=141; _prefix='[debug] '; ;;
    *)
        _color=$1; ;;
    esac

    if [[ $_no_prefix == 'true' ]]; then _prefix=''; fi
    if [[ $_new_line == 'true' ]]; then
        echo "${_esc}[38;5;${_color}m${_prefix}${_str}${_reset}"
    else
        echo -n "${_esc}[38;5;${_color}m${_prefix}${_str}${_reset}"
    fi
    OPTIND=0
}
# Parameters:
#   $1: 主颜色
#   $2: 强调色
#   $3: message
#   .....
function accent_color_print() {
    OPTIND=0
    declare _accent_pattern=1
    while getopts :p: _option; do
        case $_option in
            p)  _accent_pattern=$OPTARG ;;
            *)  echo 'error in function accent_color_print'; exit 1; ;;
        esac
    done
    shift $((OPTIND - 1))

    case $_accent_pattern in
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
# Options: (option必须在普通参数前面)
#   -d: 添加这个选项的话, 将会使用点来代替数字
# Parameters:
#   $1: seconds
function count_down() {
    OPTIND=0
    declare _use_dot='false'
    declare _option
    while getopts :d _option; do
        case $_option in
            d)  _use_dot='true' ;;
            *)  echo 'error in function count_down'; exit 1; ;;
        esac
    done
    shift $((OPTIND - 1))

    declare _i
    if [[ $_use_dot == 'true' ]]; then
        for _i in $(seq $1 -1 1); do
            color_print -n 102 '.'
            sleep 1
        done
        echo ''
    else
        for _i in $(seq $1 -1 1); do
            echo -n "$i " | color_print -n 102
            sleep 1
        done
        color_print 102 '0'
    fi
    OPTIND=0
}
# Parameters:
#   $1: divider charactor
function print_divider() {
    if [[ $# == 0 ]]; then
        eval "printf '%.0s'= {1..$(tput cols)}"     # 输出: 和窗口一样长的======
    else
        eval "printf '%.0s'$1 {1..$((  $(tput cols) / ${#1}  ))}"
    fi
}
# Parameters:
#   $1: color code. 0~255
#   $2: 提示用户的信息
# Return: 回答 --> $answer
# Usage:
#   yes_or_no info 'Are you ready?'; echo $answer
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
# 代入数组的方法: array=${_your_array[@]}
# Parameters:
#   $1: color code. 0~255
#   $2: 提示用户的信息
# Return: 回答 --> $answer
# Usage:
#   array=${_your_array[@]}; select_one info '选个吧'; echo $answer
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
# Retuen: 被执行脚本所在文件夹的绝对路径
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
        os='Ubuntu'
    elif grep -sq '^NAME="CentOS' /etc/os-release; then
        os='CentOS'
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

# Return: 'yes' / 'no' --> $answer
function check_user_is_sudoer() {
    declare _sudoer_group=''
    if [[ $os == 'Ubuntu' ]]; then _sudoer_group='sudo'; fi
    if [[ $os == 'CentOS' ]]; then _sudoer_group='wheel'; fi
    if groups | grep -sqv $_sudoer_group; then
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
    declare -r current_script_dir=$(get_current_script_dir)
    if echo $current_script_dir | grep -sq ^/root; then
        echo "当前用户: $(whoami)"
        echo "检测到该脚本位于root用户的家目录之下: $current_script_dir"
        echo '该脚本将会被删除'
        echo "脚本仓库将会安装到当前用户$(whoami)的家目录$HOME"
        echo "新的脚本将会位于$HOME/DSTManager.sh, 启动脚本请执行该文件"
        rm $0
    fi
}

function clone_repo() {
    color_print info "检测脚本仓库, 目标路径: $repo_root_dir"

    if [[ -e $repo_root_dir ]]; then
        if [[ ! -e $repo_root_dir/.git ]]; then
            color_print warn '脚本仓库可能已经损坏, 即将重新下载...'
            rm -rf $repo_root_dir > /dev/null 2>&1
        else
            color_print success '脚本仓库已存在！无需下载～'
            return 0
        fi
    else
        color_print warn '未发现脚本仓库！'
    fi

    color_print -n info "准备下载脚本仓库至$repo_root_dir "; count_down -d 3

    yes_or_no info '请问这个主机是否位于国内？'
    if [[ $answer == 'yes' ]]; then
        color_print info '远程仓库将使用gitee上的仓库'
        color_print warn 'gitee网站有时候会无法访问, 如果无法下载, 请隔一段时间重试'
        git clone $repo_url_china $repo_root_dir
    else
        color_print info '远程仓库将使用github上的仓库'
        git clone $repo_url_global $repo_root_dir
    fi

    if [[ $? == 1 ]]; then
        color_print error '脚本仓库下载失败, 请检查git命令是否可用, 也有可能远程仓库目前无法访问'
        color_print error "当前的远程仓库URL: $(git remote -v | awk '{print $2}' | uniq)"
        rm -rf $repo_root_dir > /dev/null 2>&1
        exit 1
    fi

    rm $0       # 删除被执行的脚本文件
    ln -s $repo_root_dir/DSTManager.sh $HOME/DSTManager.sh

    echo ''
    color_print success '脚本仓库下载完成！请重新运行脚本。'
    color_print info '以后运行脚本请使用该命令： ~/DSTManager.sh'
    sleep 3
    exit 0
}

# Parameters:
#   $1: package name
# Return: 'yes' / ''
function is_package_installed() {
    if [[ $os == 'Ubuntu' ]]; then
        # https://news.mynavi.jp/techplus/article/20190222-775519/
        if dpkg-query -l | awk '{print $2}' | grep -sq $1; then echo 'yes'; fi
    elif [[ $os == 'CentOS' ]]; then
        if yum list installed | grep -sq $1; then echo 'yes'; fi
    fi
}

# Return: 依赖包的数组 --> $array
function get_dependencies() {
    array=()
    if [[ $os == 'Ubuntu' ]]; then
        # 可能不需要的: lib32stdc++6 libcurl4-gnutls-dev:i386 libsdl2-2.0-0:i386
        array=(lib32gcc1 lua5.3 tmux wget git curl)
        # 32位: libgcc1 libstdc++6 libcurl4-gnutls-dev lua5.3 tmux wget git
    elif [[ $os == 'CentOS' ]]; then
        # 可能不需要的:glibc.i686
        array=(libstdc++.i686 lua.x86_64 tmux.x86_64 wget.x86_64 git.x86_64)
        # 32位: glibc libstdc++ glibc.i686 libcurl.so.4 libstdc++.so.6 tmux wget git
    fi
}

function install_dependencies() {
    check_user_is_sudoer
    declare -r _is_sudoer=$answer
    get_dependencies
    declare -a _requires=$array
    declare _manager=''
    if [[ $os == 'Ubuntu' ]]; then _manager='apt'; fi
    if [[ $os == 'CentOS' ]]; then _manager='yum'; fi

    echo ''
    color_print info '需要下载或更新的软件: '
    echo ${_requires[@]}

    if [[ $_is_sudoer == 'no' ]]; then
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

    eval "sudo $_manager update && sudo $_manager upgrade -y"
    declare _package
    for _package in ${_requires[@]}; do
        eval "sudo $_manager install -y $_package"
    done

    if [[ $os == 'CentOS' ]]; then
        # To fix: libcurl-gnutls.so.4: cannot open shared object file: No such file or directory
        sudo ln -s /usr/lib64/libcurl.so.4 /usr/lib64/libcurl-gnutls.so.4
    fi

    declare _flag=1
    for _package in ${_requires[@]}; do
        if [[ $(is_package_installed $_package) == 'yes' ]]; then
            color_print success "依赖包$_package"
        else
            color_print error "依赖包$_package"
            _flag=0
        fi
    done
    if [[ $_flag == 0 ]]; then color_print error '依赖包安装失败'; exit 1; fi
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
    if [[ -e $dst_root_dir/bin64/dontstarve_dedicated_server_nullrenderer_x64 ]]; then
        color_print success '饥荒服务端已经下载好啦～'
        return 0
    fi

    echo ''
    color_print warn "路径$dst_root_dir 未找到饥荒服务端，即将开始下载..."
    color_print -n info '根据网络状况，下载可能会很耗时间，下载完成为止请勿息屏 '; count_down 3
    if [[ -e $dst_root_dir ]]; then rm -rf $dst_root_dir > /dev/null 2>&1; fi
    mkdir -p $dst_root_dir
    ~/Steam/steamcmd.sh +force_install_dir $dst_root_dir +login anonymous +app_update 343050 validate +quit
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
            rm -rf $dst_root_dir > /dev/null 2>&1
            install_dst
        fi
    fi
}

function add_alias() {
    if ! cat ~/.bashrc | grep -sq "^alias dst="; then
        echo "alias dst='~/DSTServerManager/DSTManager.sh'" >> ~/.bashrc
        echo '' >> ~/.bashrc
    fi
    # source ~/.bashrc  --> 好像会导致报错  /etc/bashrc: line 12: PS1: unbound variable
}

function check_lua() {
    if which lua > /dev/null 2>&1; then return 0; fi

    if [[ $os == 'Ubuntu' && ! -e /usr/bin/lua ]]; then
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
    if [[ ! -e $repo_root_dir ]]; then
        mkdir -p $repo_root_dir/.cache
    fi
    if [[ -e $repo_root_dir/.skip_requirements_check ]]; then
        mv $repo_root_dir/.skip_requirements_check $repo_root_dir/.cache/.skip_requirements_check
    fi
    if [[ -e $repo_root_dir/.need_update ]]; then
        mv $repo_root_dir/.need_update $repo_root_dir/.cache/.need_update
    fi
}

function make_directories() {
    mkdir -p $klei_root_dir/$worlds_dir
    mkdir -p $backup_dir
    mkdir -p $mod_dir_v1
    mkdir -p $mod_dir_v2
    mkdir -p $repo_root_dir/.cache/modinfo
}

function check_environment() {
    check_os
    if [[ $architecture == 32 ]]; then color_print error '暂不支持32位系统'; fi
    check_user_is_root
    check_script_position

    clone_repo
    process_old_dot_file
    if [[ ! -e $repo_root_dir/.cache/.skip_requirements_check ]]; then
        add_alias
        install_dependencies
        color_print -n info '输入source ~/.bashrc 或者重写登录后, 即可使用dst来执行脚本～'; count_down -d 3
        check_lua
        make_directories
        touch $repo_root_dir/.cache/.skip_requirements_check
    fi

    install_steamcmd
    install_dst

    color_print info '即将跳转到主面板'
    sleep 1
}
clear
check_environment

##############################################################################################
for answer in $(ls $repo_root_dir/scripts/*.sh); do source $answer; done

function check_script_update() {
    tmux new -d -s 'check_script_update'
    tmux send-keys -t 'check_script_update' "if git -C $repo_root_dir remote show origin | grep -s 'main pushes' | grep -sq 'out of date'; then touch $repo_root_dir/.cache/.need_update; fi; tmux kill-session" ENTER
}

function update_repo() {
    color_print info '开始更新脚本仓库...'
    if [[ -e $repo_root_dir/.need_update ]]; then
        rm $repo_root_dir/.need_update
    fi
    git -C $repo_root_dir checkout .
    git -C $repo_root_dir pull
    if [[ $? == 1 ]]; then
        color_print error '脚本仓库更新失败, 请检查git命令是否可用, 也有可能远程仓库目前无法访问'
        color_print error "当前的远程仓库URL: $(git remote -v | awk '{print $2}' | uniq)"
        return
    fi
    color_print success '脚本仓库更新完毕！'
}

function main_panel_header() {
    print_divider '=' | color_print 208

    color_print 208 " DST Dedicated Server Manager $script_version"
    color_print 70  ' 本脚本由yechentide制作, 完全免费! 有问题可以在百度贴吧@夜尘tide'
    color_print 70  ' 本脚本一切权利归作者所有, 未经许可禁止使用本脚本进行任何的商业活动!'
    color_print 22  ' Github仓库: https://github.com/yechentide/DSTServerManager'
    color_print 22  ' Gitee仓库: https://gitee.com/yechentide/DSTServerManager'
    color_print 22  ' 欢迎会shellscript的伙伴来一起写开服脚本！'

    print_divider '-' | color_print 208

    if [[ -e $repo_root_dir/.need_update ]]; then
        color_print info '～～～检测到脚本有新版本～～～'
        print_divider '-' | color_print 208
    fi
}

##############################################################################################

function display_running_clusters() {
    declare -r -a _running_cluster_list=$(generate_list_from_tmux -s | tr '\n' ' ')
    color_print 30 "运行中的世界 ==> $_running_cluster_list"
}

function main_panel() {
    check_script_update
    declare -r -a _action_list=('服务端管理' '存档管理' 'Mod管理' '更新脚本' '退出')

    while true; do
        clear
        main_panel_header
        echo ''
        color_print 208 '>>>>>> >>>>>> 主面板 <<<<<< <<<<<<'
        display_running_clusters

        color_print info '[退出或中断操作请直接按 Ctrl加C ]'
        array=${_action_list[@]}; select_one
        declare -r _action=$answer

        case $_action in
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
            color_print -n error "${_action}功能暂未写好"; count_down -d 3
            ;;
        esac
    done
}

main_panel
