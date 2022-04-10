#######################################
# 作用: 包装read命令, 用color_print()添加引导
# 参数:
#   $1: 颜色代码(0~255) or 特定的字符串
#   $2: 提示用户的信息
#   $3: (可省略)颜色代码(0~255) or 特定的字符串
#   $4: (可省略)追加的提示
# 返回:
#   用户的输入   储存在全局变量answer
#######################################
function read_line() {
    answer=''
    color_print $1 "$2"
    if [[ $# == 4 ]]; then
        color_print $3 "$4"
    fi
    while true; do
        read -p '> ' answer
        if [[ ${#answer} == 0 ]]; then
            color_print error '输入不能为空!'
            continue
        fi
        break
    done
}

#######################################
# 作用: 多选多
# 参数:
#   $1: 颜色代码(0~255) or 特定的字符串
#   $2: 提示用户的信息
# 返回:
#   用户的选择   储存在全局变量array
#######################################
function multi_select() {
    declare -a result=()
    PS3='(多选请用空格隔开)请输入选项数字> '
    color_print $1 "$2"

    while true; do
        select answer in ${array[@]}; do break; done
        declare item=''
        for item in ${REPLY[@]}; do
            if [[ ! $item =~ ^[0-9]+$ ]] || [[ $item -le 0 ]] || [[ $item -gt ${#array[@]} ]]; then
                color_print warn "请输入正确数字。错误输入将被无视: $item"
                continue
            fi

            declare index=$(( $item - 1 ))
            result+=(${array[index]})
        done
        if [[ ${#result[@]} -gt 0 ]]; then break; fi
    done
    array=(${result[@]})
    color_print -n info "你选择的: ${result[*]}"; count_down -d 3
}

#######################################
# 作用: 查找存档文件夹, 输出存档/世界名字
# 参数:
#   注意: 下面必须至少用一个
#   -c: cluster加进list
#   -s: shard加进list
# 输出:
#   存档1 存档2 存档2-Main 存档2-Cave
#######################################
function generate_list_from_dir() {
    OPTIND=0
    declare add_cluster='false'
    declare add_shard='false'

    declare option
    while getopts :cs option; do
        case $option in
            c)  add_cluster='true'; ;;
            s)  add_shard='true'; ;;
            *)  echo 'error in function generate_list_from_dir'; exit 1; ;;
        esac
    done
    shift $((OPTIND - 1))

    if [[ $add_cluster == 'false' && $add_shard == 'false' ]]; then return 0; fi

    declare -r worlds_dir_path="$KLEI_ROOT_DIR/$WORLDS_DIR"
    if [[ $add_cluster == 'true' ]]; then
        find $worlds_dir_path -maxdepth 2 -type d | sed -e "s#$worlds_dir_path##g" | sed -e "s#^/##g" | grep -v '^\s*$' | grep -v /
    fi
    if [[ $add_shard == 'true' ]]; then
        find $worlds_dir_path -maxdepth 2 -type d | sed -e "s#$worlds_dir_path##g" | sed -e "s#^/##g" | grep -v '^\s*$' | grep / | sed -e "s#/#-#g"
    fi
    OPTIND=0
}

#######################################
# 作用: 查找tmux的session列表, 输出存档/世界名字
# 参数:
#   注意: 下面必须至少用一个
#   -c: cluster加进list
#   -s: shard加进list
# 输出:
#   存档1 存档2 存档2-Main 存档2-Cave
#######################################
function generate_list_from_tmux() {
    OPTIND=0
    declare add_cluster='false'
    declare add_shard='false'

    declare option
    while getopts :cs option; do
        case $option in
            c)  add_cluster='true'; ;;
            s)  add_shard='true'; ;;
            *)  echo 'error in function generate_list_from_tmux'; exit 1; ;;
        esac
    done
    shift $((OPTIND - 1))

    if [[ $add_cluster == 'false' && $add_shard == 'false' ]]; then return 0; fi

    if [[ $add_cluster == 'true' ]]; then
        tmux ls 2>&1 | grep -s : | awk '{print $1}' | sed -e "s/://g" | grep - | awk -F- '{print $1}' | uniq
    fi
    if [[ $add_shard == 'true' ]]; then
        tmux ls 2>&1 | grep -s : | awk '{print $1}' | sed -e "s/://g" | grep - | sort -r
    fi
    OPTIND=0
}

#######################################
# 作用: 输出存档里的世界文件夹名
# 参数:
#   -c: 存档名也输出
#   $1: 存档文件夹名
# 输出:
#   存档1 Main Cave
#######################################
function generate_list_from_cluster() {
    OPTIND=0
    declare add_cluster='false'

    declare option
    while getopts :c option; do
        case $option in
            c)  add_cluster='true'; ;;
            *)  echo 'error in function generate_list_from_cluster'; exit 1; ;;
        esac
    done
    shift $((OPTIND - 1))

    declare -r worlds_dir_path="$KLEI_ROOT_DIR/$WORLDS_DIR"
    declare -r cluster_dir_path="$worlds_dir_path/$1"
    if [[ $add_cluster == 'true' ]]; then
        find $cluster_dir_path -maxdepth 1 -type d | sed -e "s#$worlds_dir_path/##g" | grep -v /
    fi
    find $cluster_dir_path -maxdepth 1 -type d | sed -e "s#$cluster_dir_path##g" | sed -e "s#^/##g" | grep -v '^\s*$' | sort -r
    OPTIND=0
}

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
# 作用: 检测指定世界是否存在于tmux的session列表里
# 参数:
#   $1: 存档名-世界名
# 输出:
#   'yes' / 'no'
#######################################
function is_shard_running() {
    if tmux ls 2>&1 | grep -sq "$1"; then echo 'yes'; else echo 'no'; fi
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

function get_mods_from_dir() {
    find $V1_MOD_DIR -maxdepth 1 -type d -name workshop*
    find $V2_MOD_DIR -mindepth 2 -maxdepth 2 -type d
}

#######################################
# 作用: 从modinfo.lua文件里面提取模组名字
# 参数:
#   $1: modinfo.lua文件的绝对路径
# 输出:
#   mod名字
#######################################
function get_mod_name_from_modinfo() {
    # echo "$(cat $1 | grep ^name | awk -F= '{print $2}' | awk -F\" '{print $2}')"
    declare -r name=$(lua -e "locale = \"zh\"; folder_name = \"\"; dofile(\"$1\") print(name)")
    echo $name     # 通过echo来去除头尾的空白
}

#######################################
# 作用: 从dedicated_server_mods_setup.lua提取mod id列表
# 输出:
#   123456 123456 123456
#######################################
function generate_mod_id_list_from_setting_file() {
    declare -r file_path="$V1_MOD_DIR/dedicated_server_mods_setup.lua"
    cat $file_path | grep '^ServerModSetup' | awk -F\" '{print $2}'
}
