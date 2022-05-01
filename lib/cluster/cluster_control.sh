#######################################
# 作用: 去除worldgenoverride.lua文件里的'KLEI     1'
# 参数:
#   $1: 世界文件夹的绝对路径
#######################################
function remove_klei_from_worldgenoverride() {
    if head -n 1 $1/worldgenoverride.lua | grep -sq 'KLEI'; then
        sed -i -e 's/^KLEI     1 //g' $1/worldgenoverride.lua
    fi
}

#######################################
# 作用: 粗略检测指定存档文件夹是否符合要求
# 参数:
#   $1: 存档文件夹的绝对路径
# 返回:
#   0 / 1
#######################################
function check_cluster() {
    if [[ ! -e $1/cluster.ini ]]; then
        accent_color_print -p 2 error 36 '在 ' $1 ' 里未能找到 ' 'cluster.ini' '文件!'; return 1
    fi
    if [[ ! -e $1/cluster_token.txt ]]; then
        accent_color_print -p 2 error 36 '在 ' $1 ' 里未能找到 ' 'cluster_token.txt' '文件!'; return 1
    fi
    return 0
}

#######################################
# 作用: 粗略检测指定世界文件夹是否符合要求
# 参数:
#   $1: 世界文件夹的绝对路径
# 返回:
#   0 / 1
#######################################
function check_shard() {
    # 导入世界功能做好了再加上这个检测
    #if [[ ! -e $1/.dstsm ]]; then
    #    accent_color_print warn 36 '世界 ' $1 ' 不符合本脚本要求!'
    #    accent_color_print -p 2 warn 36 '在 ' $1 ' 里未能找到 ' '.dstsm' ' 文件!'
    #    color_print tip '.dstsm文件的作用是, 判断世界是否是由本脚本生成的'
    #    return 1
    #fi
    if [[ ! -e $1/server.ini ]]; then
        accent_color_print -p 2 error 36 '在 ' $1 ' 里未能找到 ' 'server.ini' '文件!'; return 1
    fi
    if [[ ! -e $1/worldgenoverride.lua ]]; then
        accent_color_print -p 2 error 36 '在 ' $1 ' 里未能找到 ' 'worldgenoverride.lua' '文件!'
        if [[ -e $1/leveldataoverride.lua ]]; then
            accent_color_print -p 2 warn 36 '在 ' $1 ' 里发现 ' 'leveldataoverride.lua' '文件!'
            accent_color_print '用来开服的存档应该把这个文件改名为' 'worldgenoverride.lua' '!'
            color_print warn 'worldgenoverride.lua的格式和leveldataoverride.lua也稍微有点不同'
            accent_color_print -c 2 tip 36 '具体格式请参考 ' "$REPO_ROOT_DIR/templates" ' 里的 ' 'shard_main/shard_cave' ' 文件夹里的worldgenoverride.lua'
        fi
        return 1
    fi
    return 0
}
