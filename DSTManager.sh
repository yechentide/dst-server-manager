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

# one line command setup:
# cd ~ && git clone https://gitee.com/yechentide/DSTServerManager && ln -s ~/DSTServerManager/DSTManager.sh ~/DSTManager.sh

set -eu

###### ###### ###### ###### ###### ######
# 删除这部分
echo '感谢使用本脚本～'
echo '但！是！'; sleep 1
echo '貌似脚本里有好多bug，我深感心痛！'
echo '为了大家能有个更好的开服体验，请暂时停止使用本脚本！'
echo '我慢慢修，多加点检测。。。'
echo ''
echo '另外，如果想继续用的话，手动删除DSTManager.sh文件的21～38行'
echo '上传脚本的骚操作好多，我之前考虑的是用不要切换用户，直接用一行命令下载。'
echo '但你们直接把不完整的仓库扔root里了。。'
echo ''
echo '推荐下载方法：运行下面命令'
echo 'cd ~ && git clone https://gitee.com/yechentide/DSTServerManager && ln -s ~/DSTServerManager/DSTManager.sh ~/DSTManager.sh'
echo '然后就是日常运行脚本： ~/DSTManager.sh'
exit 1
# 删除部分到这位置
###### ###### ###### ###### ###### ######

declare -r script_version='v1.2.3'
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

function display_running_clusters() {
    declare _running_cluster_list=''
    
    if ! (tmux ls 2>&1 | grep 'no server' > /dev/null 2>&1); then
        _running_cluster_list=$(tmux ls | awk -F- '{print $1}' | sort | uniq | tr '\n' ' ')
    fi
    
    color_print 39 "运行中的世界 ==> $_running_cluster_list"
}

function main_panel() {
    clear
    main_panel_header
    declare -r -a _action_list=('服务端管理' '存档管理' 'Mod管理' '更新脚本' '退出')
    PS3="$(color_print info '[退出或中断操作请直接按 Ctrl加C ]')"$'\n''请输入选项数字> '
    declare _selected

    while true; do
        echo ''
        color_print 215 '>>>>>> >>>>>> 主面板 <<<<<< <<<<<<'
        display_running_clusters

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
