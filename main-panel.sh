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
# - [ ] Cluster目录提醒
# - [ ] 选择Cluster功能
# - [ ] 检测Cluster里面是否存在地表/地底文件夹
# - [ ] Mod添加/删除功能
# - [ ] 存档备份/还原/删除功能
# - [ ] 白名单/黑名单/管理员名单管理功能
# - [ ] 支持仅开启地表，仅开启地底，地表地底都开
##############################################################################################

set -eu

cd ~
if [[ ! -e ~/server-manage-scripts ]]; then
    git clone https://gitee.com/yechentide/DSTServerManager.git
    if [[ $? == 1 ]]; then
        echo '仓库下载失败, 请检查git命令是否可用'
        exit 1
    fi
fi

source ./utils/output.sh

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

source ./scripts/prepare.sh

DST_ROOT_DIR="$HOME/server"
KLEI_ROOT_DIR="$HOME/klei"

WORLDS_DIR='worlds'
DEFAULT_SHARD_MAIN='Main'
DEFAULT_SHARD_CAVE='Cave'

function check_script_update() {
    if git remote show gitee | grep 'up to date' > /dev/null 2>&1; then
        echo '当前脚本为最新版本'
    else
        echo '当前脚本不是最新版本! 请及时更新脚本!'
    fi
}

function main_panel_header() {
    print_divider '=' | color_print 215
    center_print "DST Dedicated Server Manager $SCRIPT_VERSION" | color_print 215
    #check_script_update | center_print | color_print 215
    center_print '本脚本由yechentide制作, 完全免费! 有问题可以在百度贴吧@夜尘tide' | color_print 70
    center_print '本脚本一切权利归作者所有, 未经许可禁止使用本脚本进行任何的商业活动!' | color_print 70
    center_print 'Github仓库: https://github.com/yechentide/DSTServerManager' | color_print 22
    center_print 'Gitee仓库: https://gitee.com/yechentide/DSTServerManager' | color_print 22
    center_print '欢迎会shellscript的伙伴来一起写开服脚本！' | color_print 22
    print_divider '-' | color_print 215
}

function main_panel() {
    while true; do
        clear
        main_panel_header

        action_list=('新建世界' '启动服务端' '关闭服务端' '重启服务端' '退出')
        PS3="$(color_print info '[退出或中断操作请直接按 Ctrl加C ]')"$'\n'"请输入选项数字> "
        select selected in ${action_list[*]}; do break; done

        if [[ ${#selected} == 0 ]]; then
            color_print error '请输入数字！数字！数字！ ' -n; count_down 3
            continue
        fi

        color_print 39 $selected
        case $selected in
        '退出')
            color_print info '感谢你的使用 ✧٩(ˊωˋ*)و✧'
            exit 0
            ;;
        '新建世界')
            echo -n 'create a new cluster '
            count_down 3
            ;;
        *)
            color_print error "${selected}功能暂未写好 " -n; count_down 3
            continue
            ;;
        esac
        
    done
}

check_requirements $OS $ARCHITECTURE $DST_ROOT_DIR
main_panel
