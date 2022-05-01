#######################################
# 作用: 创建世界(shard)
# 参数:
#   $1: 存档文件夹的绝对路径
#   $2: 世界文件夹名
#######################################
function create_shard() {
    array=('地上世界' '洞穴世界')
    select_one info '该世界是...'

    # 复制shard模板过去
    if [[ $answer == '地上世界' ]]; then
        cp -r $REPO_ROOT_DIR/templates/shard_forest $1/$2
    else
        cp -r $REPO_ROOT_DIR/templates/shard_cave $1/$2
    fi

    # 编辑server.ini
    color_print -n warn '如果本世界是主世界的话, 接下来请把"是否为主世界"选项改成true'; count_down -d 6
    lua $REPO_ROOT_DIR/scripts/edit_shard_ini.lua $REPO_ROOT_DIR 'edit' $1/$2

    # 编辑worldgenoverride.lua
    if [[ $answer == '地上世界' ]]; then
        lua $REPO_ROOT_DIR/scripts/configure_world.lua $REPO_ROOT_DIR 'new' "$1/$2" 'true'
    else
        lua $REPO_ROOT_DIR/scripts/configure_world.lua $REPO_ROOT_DIR 'new' "$1/$2" 'false'
    fi
}

#######################################
# 参数:
#   $1: 存档文件夹的绝对路径
#   $2: 存档文件夹名
#######################################
function add_shard_to_cluster() {
    while true; do
        yes_or_no info '是否要添加地表/洞穴世界?'
        if [[ $answer == 'no' ]]; then break; fi

        color_print info '请为这个世界取个名字吧(文件夹名)'
        color_print warn '注意: 必须要有一个主世界, 最多只能有一个主世界!'
        read_line tip '地面世界的话推荐Forest, 洞穴世界的话推荐Cave, 主世界的话推荐Main'
        if [[ -e $1/$answer ]]; then
            color_print error "存档${2}里面已存在${$answer}!"
            continue
        fi
        create_shard $1 $answer
    done
}
