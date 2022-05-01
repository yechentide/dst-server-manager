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
