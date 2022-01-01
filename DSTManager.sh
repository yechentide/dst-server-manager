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

#################### ###################  TO-DO List  ################### ####################
# - [x] 开启64bit服务端
# - [x] Cluster目录提醒
# - [x] 选择Cluster功能
# - [ ] 完善 worldgenoverride.lua
# - [ ] 检测Cluster里面是否存在地表/地底文件夹
# - [x] Mod添加功能
# - [ ] Mod删除功能
# - [ ] 存档备份/还原/删除功能
# - [ ] 白名单/黑名单/管理员名单管理功能
# - [ ] 支持仅开启地表，仅开启地底，地表地底都开
# - [ ] 生成世界后修改世界选项
# - [ ] 自动更新服务端功能
# - [ ] 更多的检测机制
# - [ ] 开启测试服功能
# - [ ] 后台检测脚本更新
##############################################################################################

# one line command setup:
# cd ~ && git clone https://gitee.com/yechentide/DSTServerManager && ln -s ~/DSTServerManager/DSTManager.sh ~/DSTManager.sh

set -eu

declare -r script_version='v1.1'
declare -r repo_position=$HOME
declare -r repo_root_dir="$repo_position/DSTServerManager"
declare os='MacOS'
declare -r architecture=$(getconf LONG_BIT)

function check_repo() {
    if [[ ! -e $repo_root_dir ]]; then
        echo '未找到脚本仓库，开始下载...'
        sleep 1
        git clone https://gitee.com/yechentide/DSTServerManager.git $repo_position
        if [[ $? == 1 ]]; then
            echo '脚本仓库下载失败, 请检查git命令是否可用'
            exit 1
        fi
        rm $0
        ln -s $repo_root_dir/DSTManager.sh ~/DSTManager.sh
        echo ''
        echo '脚本仓库下载完成！请重新运行脚本。'
        echo '以后运行脚本请使用该命令：  ~/DSTManager.sh'
        sleep 1
        exit 0
    fi
}
check_repo

source $repo_root_dir/utils/output.sh

function check_os() {
    if [[ ! $(uname) == 'Linux' ]]; then color_print error '本脚本目前仅支持Linux'; exit 1; fi

    if grep '^NAME="Ubuntu' /etc/os-release > /dev/null 2>&1; then
        os='Ubuntu'
    elif grep '^NAME="CentOS' /etc/os-release > /dev/null 2>&1; then
        os='CentOS'
    #elif grep '^NAME="Amazon' /etc/os-release > /dev/null 2>&1; then
    #    OS='Amazon Linux'
    else
        color_print error '本脚本暂不支持此Linux系统：'
        uname -a | color_print error
        exit 1
    fi
}
check_os

##############################################################################################

for file in $(ls $repo_root_dir/scripts/*.sh); do source $file; done

dst_root_dir="$HOME/Server"
klei_root_dir="$HOME/Klei"
worlds_dir='worlds'
shard_main_name='Main'
shard_cave_name='Cave'

function check_script_update() {
    if git remote show gitee | grep 'up to date' > /dev/null 2>&1; then
        color_print info '当前脚本为最新版本'
    else
        color_print info '当前脚本不是最新版本! 请及时更新脚本!'
    fi
}

function main_panel_header() {
    print_divider '=' | color_print 215

    color_print 215 " DST Dedicated Server Manager $script_version"
    #check_script_update | echo | color_print 215
    color_print 70  ' 本脚本由yechentide制作, 完全免费! 有问题可以在百度贴吧@夜尘tide'
    color_print 70  ' 本脚本一切权利归作者所有, 未经许可禁止使用本脚本进行任何的商业活动!'
    color_print 22  ' Github仓库: https://github.com/yechentide/DSTServerManager'
    color_print 22  ' Gitee仓库: https://gitee.com/yechentide/DSTServerManager'
    color_print 22  ' 欢迎会shellscript的伙伴来一起写开服脚本！'

    print_divider '-' | color_print 215
}

function main_panel() {
    if [[ $? == 0 ]]; then clear; fi
    main_panel_header
    declare -r -a _action_list=('服务端管理' '存档管理' 'Mod管理' '更新脚本' '退出')
    PS3="$(color_print info '[退出或中断操作请直接按 Ctrl加C ]')"$'\n''请输入选项数字> '
    declare _selected

    #declare -r _running_cluster=''
    #if tmux ls > /dev/null 2>&1; then
    #    _running_cluster=$(tmux ls | grep - | awk -F- '{print $1}' | uniq)
    #fi

    while true; do
        echo ''
        #if [[ ${#_running_cluster} -gt 0 ]]; then
        #    color_print 39 "运行中的世界 ==> $_running_cluster"
        #else
        #    color_print 39 '运行中的世界 ==> 无'
        #fi

        select _selected in ${_action_list[@]}; do break; done
        if [[ ${#_selected} == 0 ]]; then
            color_print error '请输入数字！数字！数字！'
            continue
        fi

        case $_selected in
        '服务端管理')
            server_panel $architecture $dst_root_dir $klei_root_dir $worlds_dir $shard_main_name $shard_cave_name
            ;;
        '存档管理')
            cluster_panel $repo_root_dir $dst_root_dir $klei_root_dir $worlds_dir $shard_main_name $shard_cave_name
            ;;
        'Mod管理')
            mod_panel $architecture $repo_root_dir $dst_root_dir $klei_root_dir/$worlds_dir $shard_main_name $shard_cave_name
            ;;
        '更新脚本')
            color_print info '开始更新脚本仓库...'
            git -C $repo_root_dir pull
            color_print info '更新完毕！'
            ;;
        '退出')
            color_print info '感谢你的使用 ✧٩(ˊωˋ*)و✧'
            exit 0
            ;;
        *)
            color_print error "${_selected}功能暂未写好"
            continue
            ;;
        esac

    done
}

check_requirements $os $architecture $dst_root_dir
main_panel




#dstserver的界面管理+go.sh的功能组合到一起比较合适
#增加对Centos的支持
#force_install_dir 命令要在login anonymous之前

#在某一个版本以后，要想跑通是要把libcurl.so.4重链接的，但是go.sh有这行代码但是不知道为什么给注释掉了（这也是现在go.sh跑不通的绝大多数人遇到的问题）

#dstserver.sh启动服务器的逻辑不是很好，个人感觉go.sh的逻辑比较好。
#go.sh是从存档槽中启动, dst的逻辑是在上次启动的服务器和新服务器之间选择
