# Parameters:
#   $1: color
#   $2: message
#   $3: color(可省略)
#   $4: message(可省略)
# Return: 用户的输入  --> $answer
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
    done
}

# 代入数组的方法: array=${_your_array[@]}
# Parameters:
#   $1: color code. 0~255
#   $2: 提示用户的信息
# Return: 回答 --> $array
function multi_select() {
    declare -a _result=()
    PS3='(多选请用空格隔开)请输入选项数字> '
    color_print $1 "$2"
    select answer in ${array[@]}; do break; done
    for item in ${REPLY[@]}; do
        if [[ ! $item =~ ^[0-9]+$ ]] || [[ $item -le 0 ]] || [[ $item -gt ${#array[@]} ]]; then
            color_print warn "请输入正确数字。错误输入将被无视: $item"
            continue
        fi
        declare _index=$(( $item - 1 ))
        _result+=(${array[_index]})
    done
    array=(${_result[@]})
    color_print info "你选择的: ${_result[@]}"
    count_down -d 3
}

# Options: (option必须在普通参数前面)
#   -c: cluster加进list
#   -s: shard加进list
#   注意: 必须加至少一个option
function generate_list_from_dir() {
    OPTIND=0
    declare _add_cluster='false'
    declare _add_shard='false'

    declare _option
    while getopts :cs _option; do
        case $_option in
            c)  _add_cluster='true'; ;;
            s)  _add_shard='true'; ;;
            *)  echo 'error in function generate_list_from_dir'; exit 1; ;;
        esac
    done
    shift $((OPTIND - 1))

    if [[ $_add_cluster == 'false' && $_add_shard == 'false' ]]; then return 0; fi

    if [[ $_add_cluster == 'true' ]]; then
        find $klei_root_dir/$worlds_dir -maxdepth 2 -type d | sed -e "s#$klei_root_dir/$worlds_dir##g" | sed -e "s#^/##g" | grep -v '^\s*$' | grep -v /
    fi
    if [[ $_add_shard == 'true' ]]; then
        find $klei_root_dir/$worlds_dir -maxdepth 2 -type d | sed -e "s#$klei_root_dir/$worlds_dir##g" | sed -e "s#^/##g" | grep -v '^\s*$' | grep / | sed -e "s#/#-#g"
    fi
    OPTIND=0
}
function generate_list_from_tmux() {
    OPTIND=0
    declare _add_cluster='false'
    declare _add_shard='false'

    declare _option
    while getopts :cs _option; do
        case $_option in
            c)  _add_cluster='true'; ;;
            s)  _add_shard='true'; ;;
            *)  echo 'error in function generate_list_from_tmux'; exit 1; ;;
        esac
    done
    shift $((OPTIND - 1))

    if [[ $_add_cluster == 'false' && $_add_shard == 'false' ]]; then return 0; fi

    if [[ $_add_cluster == 'true' ]]; then
        tmux ls 2>&1 | grep -s : | awk '{print $1}' | sed -e "s/://g" | grep - | awk -F- '{print $1}' | uniq
    fi
    if [[ $_add_shard == 'true' ]]; then
        tmux ls 2>&1 | grep -s : | awk '{print $1}' | sed -e "s/://g" | grep -
    fi
    OPTIND=0
}
# Options: (option必须在普通参数前面)
#   -c: cluster加进list
# Parameters:
#   $1: cluster name
function generate_list_from_cluster() {
    OPTIND=0
    declare _add_cluster='false'

    declare _option
    while getopts :cs _option; do
        case $_option in
            c)  _add_cluster='true'; ;;
            *)  echo 'error in function generate_list_from_cluster'; exit 1; ;;
        esac
    done
    shift $((OPTIND - 1))

    if [[ $_add_cluster == 'true' ]]; then
        find $klei_root_dir/$worlds_dir/c01 -maxdepth 1 -type d | sed -e "s#$klei_root_dir/$worlds_dir/##g" | grep -v /
    fi
    find $klei_root_dir/$worlds_dir/c01 -maxdepth 1 -type d | sed -e "s#$klei_root_dir/$worlds_dir/c01##g" | sed -e "s#^/##g" | grep -v '^\s*$'
    OPTIND=0
}

# Parameters:
#   $1: shard dir         ~/Klei/worlds/cluster_name/shard
function remove_klei_from_worldgenoverride() {
    if head -n 1 $1/worldgenoverride.lua | grep -sq 'KLEI'; then
        sed -i -e 's/^KLEI     1 //g' $1/worldgenoverride.lua
    fi
}

# Parameters:
#   $1: shard name    例: c01-Main
# Return:
#   'yes' / 'no'
function is_shard_running() {
    if tmux ls 2>&1 | grep -sq "$1"; then echo 'yes'; else echo 'no'; fi
}

# Parameters:
#   $1: cluster dir         ~/Klei/worlds/cluster_name
# Return: 0 / 1
function check_cluster() {
    if [[ ! -e $1/cluster.ini ]]; then
        accent_color_print -p 2 error 36 '在 ' $1 ' 里未能找到 ' 'cluster.ini' '文件!'; return 1
    fi
    if [[ ! -e $1/cluster_token.txt ]]; then
        accent_color_print -p 2 error 36 '在 ' $1 ' 里未能找到 ' 'cluster_token.txt' '文件!'; return 1
    fi
    return 0
}

# Parameters:
#   $1: shard dir         ~/Klei/worlds/cluster_name/shard
# Return: 0 / 1
function check_shard() {
    if [[ ! -e $1/server.ini ]]; then
        accent_color_print -p 2 error 36 '在 ' $1 ' 里未能找到 ' 'server.ini' '文件!'; return 1
    fi
    if [[ ! -e $1/modoverrides.lua ]]; then
        accent_color_print -p 2 error 36 '在 ' $1 ' 里未能找到 ' 'modoverrides.lua' '文件!'
        if [[ -e $1/leveldataoverride.lua ]]; then
            accent_color_print -p 2 warn 36 '在 ' $1 ' 里发现 ' 'leveldataoverride.lua' '文件!'
            accent_color_print '用来开服的存档应该把这个文件改名为' 'worldgenoverride.lua' '!'
            color_print warn 'worldgenoverride.lua的格式和leveldataoverride.lua也稍微有点不同'
            accent_color_print -c 2 tip 36 '具体格式请参考 ' "$repo_root_dir/templates" ' 里的 ' 'shard_main/shard_cave' ' 文件夹里的worldgenoverride.lua'
        fi
        return 1
    fi
    return 0
}
