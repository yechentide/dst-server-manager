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
# - [ ] 完善 worldgenoverride.lua
# - [x] Cluster目录提醒
# - [x] 选择Cluster功能
# - [ ] 检测Cluster里面是否存在地表/地底文件夹
# - [ ] Mod添加/删除功能
# - [ ] 存档备份/还原/删除功能
# - [ ] 白名单/黑名单/管理员名单管理功能
# - [ ] 支持仅开启地表，仅开启地底，地表地底都开
##############################################################################################
set -eu

# one line command setup:
# cd ~ && git clone https://gitee.com/yechentide/DSTServerManager && ln -s ~/DSTServerManager/DSTManager.sh ~/DSTManager.sh

cd ~
if [[ ! -e ~/DSTServerManager ]]; then
    echo '未找到脚本仓库，开始下载...'
    git clone https://gitee.com/yechentide/DSTServerManager.git
    if [[ $? == 1 ]]; then
        echo '脚本仓库下载失败, 请检查git命令是否可用'
        exit 1
    fi
    rm $0
    ln -s ~/DSTServerManager/DSTManager.sh ~/DSTManager.sh
    echo '脚本仓库下载完成！'
    echo '请重新运行脚本。使用命令为：  ~/DSTManager.sh'
    sleep 1
fi

source ~/DSTServerManager/utils/output.sh

SCRIPT_VERSION='v0.1'
OS='MacOS'
ARCHITECTURE=$(getconf LONG_BIT)

function check_os() {
    if [[ ! $(uname) == 'Linux' ]]; then color_print error '本脚本目前仅支持Linux'; exit 1; fi

    if grep '^NAME="Ubuntu' /etc/os-release > /dev/null 2>&1; then
        OS='Ubuntu'
    elif grep '^NAME="CentOS' /etc/os-release > /dev/null 2>&1; then
        OS='CentOS'
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

for file in $(ls ~/DSTServerManager/scripts/*.sh); do source $file; done

DST_ROOT_DIR="$HOME/Server"

KLEI_ROOT_DIR="$HOME/Klei"
WORLDS_DIR='worlds'
SHARD_MAIN='Main'
SHARD_CAVE='Cave'

function check_script_update() {
    if git remote show gitee | grep 'up to date' > /dev/null 2>&1; then
        echo '当前脚本为最新版本'
    else
        echo '当前脚本不是最新版本! 请及时更新脚本!'
    fi
}

function main_panel_header() {
    print_divider '=' | color_print 215
    echo " DST Dedicated Server Manager $SCRIPT_VERSION" | color_print 215
    #check_script_update | echo | color_print 215
    echo ' 本脚本由yechentide制作, 完全免费! 有问题可以在百度贴吧@夜尘tide' | color_print 70
    echo ' 本脚本一切权利归作者所有, 未经许可禁止使用本脚本进行任何的商业活动!' | color_print 70
    echo ' Github仓库: https://github.com/yechentide/DSTServerManager' | color_print 22
    echo ' Gitee仓库: https://gitee.com/yechentide/DSTServerManager' | color_print 22
    echo ' 欢迎会shellscript的伙伴来一起写开服脚本！' | color_print 22
    print_divider '-' | color_print 215
}

function main_panel() {
    clear
    main_panel_header
    action_list=('新建世界' '启动服务端' '关闭服务端' '重启服务端' '升级服务端' '添加Mod' '更新脚本' '退出')
    PS3="$(color_print info '[退出或中断操作请直接按 Ctrl加C ]')"$'\n'"请输入选项数字> "

    running_cluster=''
    if tmux ls > /dev/null 2>&1; then
        running_cluster=$(tmux ls | grep - | awk -F- '{print $1}' | uniq)
    fi

    while true; do
        echo ''
        if [[ ${#running_cluster} -gt 0 ]]; then
            color_print 39 "运行中的世界 ==> $running_cluster"
        else
            color_print 39 '运行中的世界 ==> 无'
        fi

        select selected in ${action_list[*]}; do break; done
        if [[ ${#selected} == 0 ]]; then
            color_print error '请输入数字！数字！数字！'
            continue
        fi

        case $selected in
        '新建世界')
            create_cluster $DST_ROOT_DIR $KLEI_ROOT_DIR $WORLDS_DIR $SHARD_MAIN $SHARD_CAVE
            ;;
        '启动服务端')
            running_cluster=$(select_cluster $KLEI_ROOT_DIR/$WORLDS_DIR)
            if [[ $? == 1 ]]; then
                color_print error '选择世界时发生错误，请检查输入以及是否有存档'
                continue
            fi
            if tmux ls | grep $running_cluster > /dev/null 2>&1; then
                color_print error "世界$running_cluster已经开启！"
                continue
            fi
            start_server $ARCHITECTURE $DST_ROOT_DIR $KLEI_ROOT_DIR $WORLDS_DIR $running_cluster $SHARD_MAIN $SHARD_CAVE
            ;;
        '关闭服务端')
            stop_server $running_cluster $SHARD_MAIN $SHARD_CAVE
            running_cluster=''
            ;;
        '重启服务端')
            if [[ ${#running_cluster} == 0 ]]; then
                color_print error '没有开启中的世界！'
                continue
            fi
            color_print info "正在关闭世界$running_cluster..."
            stop_server $running_cluster $SHARD_MAIN $SHARD_CAVE
            sleep 5
            color_print info "重新开启世界$running_cluster..."
            start_server $ARCHITECTURE $DST_ROOT_DIR $KLEI_ROOT_DIR $WORLDS_DIR $running_cluster $SHARD_MAIN $SHARD_CAVE
            sleep 5
            color_print info "世界$running_cluster已经开启！"
            ;;
        '升级服务端')
            if [[ ${#running_cluster} != 0 ]]; then
                stop_server $running_cluster $SHARD_MAIN $SHARD_CAVE
                running_cluster=''
                sleep 5
            fi
            update_server $DST_ROOT_DIR
            ;;
        '添加Mod')
            add_mods $DST_ROOT_DIR $KLEI_ROOT_DIR/$WORLDS_DIR $SHARD_MAIN $SHARD_CAVE
            ;;
        '更新脚本')
            color_print info '开始更新脚本仓库...'
            cd ~/DSTServerManager && git pull
            color_print info '更新完毕！'
            ;;
        '退出')
            color_print info '感谢你的使用 ✧٩(ˊωˋ*)و✧'
            exit 0
            ;;
        *)
            color_print error "${selected}功能暂未写好"
            continue
            ;;
        esac
        
    done
}

check_requirements $OS $ARCHITECTURE $DST_ROOT_DIR
main_panel
