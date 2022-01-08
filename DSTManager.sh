#!/usr/bin/env bash

#################### #################### References #################### ####################
# https://dontstarve.fandom.com/wiki/Guides/Don%E2%80%99t_Starve_Together_Dedicated_Servers
# https://steamcommunity.com/id/ToNiO44/myworkshopfiles/?section=guides&appid=322330
##############################################################################################

#################### ################### Repositories ################### ####################
# 作者: yechentide      贴吧@夜尘tide
# Github: https://github.com/yechentide/DSTServerManager
# Gitee:  https://gitee.com/yechentide/DSTServerManager
# 主要使用Github，上传Gitee只是单纯为了方便国内VPS下载...
# 欢迎会shellscript的伙伴来一起写开服脚本！
##############################################################################################

set -eu

declare os='MacOS'
declare -r script_version='v1.3.0.6'
declare -r architecture=$(getconf LONG_BIT)
declare -r repo_root_dir="$HOME/DSTServerManager"

declare dst_root_dir="$HOME/Server"
declare klei_root_dir="$HOME/Klei"
declare worlds_dir='worlds'
declare shard_main_name='Main'
declare shard_cave_name='Cave'

# 名词说明: 单个地上世界 or 单个地下世界, 称为shard。一整个存档, 称为cluster。
# 名词说明: 拿两个主机开一个cluster, 称为multi-server

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
# Parameters:
#   $1: color code. 0~255
#   $2: output string
#   -n: make sure it is the last parameter. use -n option of echo.
function color_print() {
    declare -r _esc=$(printf "\033")    # 更改输出颜色用的前缀
    declare -r _reset="${_esc}[0m"      # 重置所有颜色，字体设定

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
    'success')   # 绿
        _color=46; _prefix='[OK] '; ;;
    'error')    # 红
        _color=196; _prefix='[ERROR] '; ;;
    'log')      # 橙
        _color=215; _prefix='[LOG] '; ;;
    'debug')
        _color=141; _prefix='[debug] '; ;;
    *)
        _color=$1; ;;
    esac

    if echo $@ | grep -sq ' \-n'; then
        echo -n "${_esc}[38;5;${_color}m${_prefix}${_str}${_reset}"
    else
        echo "${_esc}[38;5;${_color}m${_prefix}${_str}${_reset}"
    fi
}
# Parameters:
#   $1: seconds
#   dot: make sure it is the last parameter. output dot instead number.
function count_down() {
    if echo $@ | grep -sq 'dot'; then
        for i in $(seq $1 -1 1); do
            echo -n '.' | color_print 102 -n
            sleep 1
        done
        echo ''
    else
        for i in $(seq $1 -1 1); do
            echo -n "$i " | color_print 102 -n
            sleep 1
        done
        color_print 102 '0'
    fi
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
#   $1: answer(在函数内部会更改这个参数原来位置的值), 注意传进来的是变量名(也就是不加$)
#   $2: color code. 0~255
#   $3: 提示用户的信息
function yes_or_no() {
    declare -n _tmp="$1"
    declare _selected
    PS3='请输入选项数字> '

    while true; do
        if [[ $# -lt 3 ]]; then
            color_print $2 '请确认...'
        else
            color_print $2 $3
        fi
        select _selected in yes no; do break; done
        if [[ ${#_selected} == 0 ]]; then
            color_print error '请输入正确的数字！'
            continue
        fi
        _tmp=$_selected
        return 0
    done
}
# Parameters:
#   $1: array           注意传进来的是变量名(也就是不加$)
#   $2: selected one    (在函数内部会更改这个参数原来位置的值), 注意传进来的是变量名(也就是不加$)
function select_one() {
    declare -n _array="$1"
    declare -n _selected="$2"
    PS3='请输入选项数字> '

    while true; do
        color_print info '请从下面选择一个选项'
        select _selected in ${_array[@]}; do break; done
        if [[ ${#_selected} == 0 ]]; then
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
        exit 1
    fi
}

function check_user_is_root() {
    if echo $HOME | grep -sq ^/root; then
        color_print error '请勿使用root用户执行本脚本！'
        exit 1
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
        echo "新的脚本将会位于$HOME/DSTManager.sh"
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

    color_print info "准备下载脚本仓库至$repo_root_dir " -n; count_down 3 dot

    declare _is_server_in_china
    yes_or_no _is_server_in_china info '请问这个主机是否位于国内？'
    if [[ $_is_server_in_china == 'yes' ]]; then
        declare -r _repo_url='https://gitee.com/yechentide/DSTServerManager'
        color_print info '远程仓库将使用gitee上的仓库'
        color_print warn 'gitee网站有时候会无法访问, 如果无法下载, 请隔一段时间重试'
    else
        declare -r _repo_url='https://github.com/yechentide/DSTServerManager'
        color_print info '远程仓库将使用github上的仓库'
    fi

    git clone $_repo_url $repo_root_dir

    if [[ $? == 1 ]]; then
        color_print error '脚本仓库下载失败, 请检查git命令是否可用, 也有可能远程仓库目前无法访问'
        color_print error "当前的远程仓库URL: $(git remote -v | awk '{print $2}' | uniq)"
        rm -rf $repo_root_dir > /dev/null 2>&1
        exit 1
    fi

    rm $0
    ln -s $repo_root_dir/DSTManager.sh $HOME/DSTManager.sh

    echo ''
    color_print success '脚本仓库下载完成！请重新运行脚本。'
    color_print info '以后运行脚本请使用该命令：  ~/DSTManager.sh'
    sleep 3
    exit 0
}

function update_repo() {
    color_print info '开始更新脚本仓库...'
    rm $repo_root_dir/.need_update > /dev/null 2>&1
    git -C $repo_root_dir pull
    if [[ $? == 1 ]]; then
        color_print error '脚本仓库更新失败, 请检查git命令是否可用, 也有可能远程仓库目前无法访问'
        color_print error "当前的远程仓库URL: $(git remote -v | awk '{print $2}' | uniq)"
        return
    fi
    color_print success '脚本仓库更新完毕！'
}

# Parameters:
#   $1: package
# Return: 'yes' / ''
function is_package_installed() {
    if [[ $os == 'Ubuntu' ]]; then
        # https://news.mynavi.jp/techplus/article/20190222-775519/
        if dpkg-query -l | awk '{print $2}' | grep -sq $1; then echo 'yes'; fi
    fi
    if [[ $os == 'CentOS' ]]; then
        if yum list installed | grep -sq $1; then echo 'yes'; fi
    fi
}

# Return: 依赖包的数组
function get_dependencies() {
    declare -a _requires
    if [[ $os == 'Ubuntu' ]]; then
        if [[ $architecture == 64 ]]; then
            # 可能不需要的: lib32stdc++6 libcurl4-gnutls-dev:i386 libsdl2-2.0-0:i386
            _requires=(lib32gcc1 lua5.3 tmux wget git)
        else
            color_print error '暂不支持32位Ubuntu'; exit 1      #_requires=(libgcc1 libstdc++6 libcurl4-gnutls-dev lua5.3 tmux wget git)
        fi
    elif [[ $os == 'CentOS' ]]; then
        if [[ $architecture == 64 ]]; then
            # 可能不需要的:glibc.i686
            _requires=(libstdc++.i686 lua.x86_64 tmux.x86_64 wget.x86_64 git.x86_64)
        else
            color_print error '暂不支持32位CentOS'; exit 1      #_requires=(glibc libstdc++ glibc.i686 libcurl.so.4 libstdc++.so.6 tmux wget git)
        fi
    else
        color_print error "本脚本暂不支持当前系统版本"; exit 1
    fi
    echo ${_requires[@]}
}

# Return: 0 / 1
function check_user_is_sudoer() {
    declare _sudoer_group=''
    if [[ $os == 'Ubuntu' ]]; then _sudoer_group='sudo'; fi
    if [[ $os == 'CentOS' ]]; then _sudoer_group='wheel'; fi
    if groups | grep -sqv $_sudoer_group; then
        color_print warn "当前用户$(whoami)没有sudo权限, 可能无法下载依赖。"
        color_print warn '接下来将会列出所需依赖包, 如果不确定是否已安装, 请终止脚本！'
        color_print warn "有需要的话请联系管理员获取sudo权限, 或者帮忙下载依赖！ " -n; count_down 3 dot
        return 1
    else
        return 0
    fi
}

function install_dependencies() {
    declare _is_sudoer
    if check_user_is_sudoer; then _is_sudoer='yes'; else _is_sudoer='no'; fi
    declare -a _requires=$(get_dependencies)
    declare _manager=''
    if [[ $os == 'Ubuntu' ]]; then _manager='apt'; fi
    if [[ $os == 'CentOS' ]]; then _manager='yum'; fi

    echo ''
    color_print info '需要下载或更新的软件: '
    echo ${_requires[@]}

    if [[ $_is_sudoer == 'no' ]]; then
        color_print warn '以上软件是否已安装？没有安装的话请联系该服务器的管理员...'
        declare _is_installed
        yes_or_no _is_installed warn '是否已安装？'
        if [[ $_is_installed == 'yes' ]]; then return 0; fi

        color_print error '无权限下载安装必须软件，终止运行脚本。请联系服务器管理员解决。'
        exit 1
    fi

    declare _start_install
    yes_or_no _start_install warn '是否要开始安装依赖？'
    if [[ $_start_install == 'no' ]]; then
        color_print error '终止安装依赖包, 结束脚本'
        exit 1
    fi

    color_print info '即将以管理员权限下载更新软件，可能会要求输入当前用户的密码 ' -n; count_down 3

    eval "sudo $_manager update && sudo $_manager upgrade -y"
    declare _package
    for _package in ${_requires[@]}; do
        eval "sudo $_manager install -y $_package"
    done

    if [[ $architecture == 64 && $os == 'CentOS' ]]; then
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

function remove_old_dot_files() {
    # 旧版本使用的文件
    if [[ -e $repo_root_dir/.first_run ]]; then rm $repo_root_dir/.first_run; fi
    if [[ -e $repo_root_dir/.skip_check ]]; then rm $repo_root_dir/.skip_check; fi
}

function install_steamcmd() {
    # https://developer.valvesoftware.com/wiki/SteamCMD#Linux
    if [[ ! -e ~/Steam ]]; then mkdir ~/Steam; fi
    if [[ -e ~/Steam/steamcmd.sh ]]; then
        color_print success 'steamcmd.sh已存在～'
        return 0
    fi

    echo ''
    color_print warn '未在~/Steam 发现steamcmd.sh，开始下载' -n; count_down 3 dot
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
    if [[ -e $dst_root_dir/bin/dontstarve_dedicated_server_nullrenderer && -e $dst_root_dir/bin64/dontstarve_dedicated_server_nullrenderer_x64 ]]; then
        color_print success '饥荒服务端已经下载好啦～'
        return 0
    fi
    
    echo ''
    color_print warn "路径$dst_root_dir 未找到饥荒服务端，即将开始下载..."
    color_print info '根据网络状况，下载可能会很耗时间，下载完成为止请勿息屏 ' -n; count_down 3
    mkdir -p $dst_root_dir
    ~/Steam/steamcmd.sh +force_install_dir $dst_root_dir +login anonymous +app_update 343050 validate +quit
    # Error: /Steam/linux32/steamcmd: No such file or directory
    # Fix: install lib32gcc1
    if [[ $? ]]; then
        color_print success '饥荒服务端下载安装完成!'
        color_print info '途中可能会出现Failed to init SDL priority manager: SDL not found警告'
        color_print info '不用担心, 这个不影响下载/更新DST'
        color_print info '虽然可以解决, 但这需要下载一堆依赖包, 有可能会对其他运行中的服务造成影响, 所以无视它吧～ ' -n; count_down 6 dot
    else
        color_print error '似乎出现了什么错误...'
        declare _try_again
        yes_or_no _tyr_again info '重新下载？'
        if [[ $_tyr_again == 'yes' ]]; then
            rm -rf $1 > /dev/null 2>&1
            install_dst
        fi
    fi
}

function check_bash_version() {
    if echo $BASH_VERSION | grep -sqv ^5.; then
        color_print error 'Bash版本过低, 请升级到5.0！'
        color_print warn '是否由脚本来执行升级操作？'
        PS3='请输入选项数字> '
        declare _selected
        select _selected in yes no; do break; done
        if [[ $_selected == 'yes' ]]; then
            color_print info '升级过程可能有点长, 请等待10分钟, 这期间请不要断开连接'
            update_bash

            if /usr/local/bin/bash --version | grep -sq 'version 5'; then
                color_print success 'Bash升级成功！请重新运行脚本！'; exit 0
            else
                color_print error '好像升级失败了...'; exit 1
            fi
        fi
        color_print info '退出脚本'
        exit 1
    fi
}

function update_bash() {
    mkdir /tmp/work && cd /tmp/work
    if [[ $os == 'Ubuntu' ]]; then
        sudo apt -y update
        sudo apt -y install curl
        sudo apt -y install build-essential
    fi
    if [[ $os == 'CentOS' ]]; then
        sudo yum -y update
        sudo yum -y install curl
        sudo yum -y groupinstall "Development Tools"
    fi
    curl -O https://ftp.gnu.org/gnu/bash/bash-5.0.tar.gz
    tar xvf bash-5.0.tar.gz
    cd bash-5.0
    ./configure
    make
    sudo make install
    cd ~
}

function add_alias() {
    echo "alias dst='~/DSTServerManager/DSTManager.sh'" >> ~/.bashrc
    if ! which lua | grep -sq lua && which lua5.3 | grep -sq lua; then
        echo "alias lua='lua5.3'" >> ~/.bashrc
    fi
    source ~/.bashrc
}

function check_environment() {
    check_os
    check_user_is_root
    check_script_position
    check_bash_version
    add_alias

    clone_repo
    if [[ ! -e $repo_root_dir/.skip_requirements_check ]]; then
        install_dependencies
        remove_old_dot_files
        touch $repo_root_dir/.skip_requirements_check
    fi

    install_steamcmd
    install_dst $dst_root_dir
    mkdir -p $klei_root_dir/$worlds_dir

    color_print info '即将跳转到主面板'
    sleep 1
}
clear
check_environment

##############################################################################################
for file in $(ls $repo_root_dir/scripts/*.sh); do source $file; done

#function check_script_update() {
    # FIXME
#    exit 1
#    tmux new -d -s 'check_script_update'
#    tmux send-keys -t 'check_script_update' "if git -C $repo_root_dir remote show origin | grep -s 'main pushes' | grep -sq 'out of date'; then touch $repo_root_dir/.need_update; fi; tmux kill-session" ENTER
#}

function display_running_clusters() {
    declare -r -a _running_cluster_list=$(generate_shard_list_from_tmux | tr '\n' ' ')
    color_print 30 "运行中的世界 ==> $_running_cluster_list"
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

function main_panel() {
    # check_script_update
    declare _action
    declare -r -a _action_list=('服务端管理' '存档管理' 'Mod管理' '更新脚本' '退出')

    while true; do
        clear
        main_panel_header
        echo ''
        color_print 208 '>>>>>> >>>>>> 主面板 <<<<<< <<<<<<'
        display_running_clusters

        color_print info '[退出或中断操作请直接按 Ctrl加C ]'
        select_one _action_list _action

        case $_action in
        '服务端管理')
            server_panel $architecture $dst_root_dir $klei_root_dir $worlds_dir
            ;;
        '存档管理')
            cluster_panel $repo_root_dir $dst_root_dir $klei_root_dir $worlds_dir $shard_main_name $shard_cave_name
            ;;
        'Mod管理')
            color_print error "${_action}功能暂未写好" -n; count_down 3 dot
            ;;
        '更新脚本')
            update_repo
            ;;
        '退出')
            color_print info '感谢你的使用 ✧٩(ˊωˋ*)و✧'
            exit 0
            ;;
        *)
            color_print error "${_action}功能暂未写好" -n; count_down 3 dot
            ;;
        esac
    done
}

main_panel
