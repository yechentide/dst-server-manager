#######################################
# 作用: 管理各种名单(白名单/黑名单/管理员名单)
# 参数:
#   $1: op / white / black
#######################################
function edit_list() {
    # KU_A1b2C3d4
    declare list_type=''
    declare file_name=''
    if [[ $1 == 'op' ]]; then
        list_type='管理员'
        file_name='adminlist.txt'
    elif [[ $1 == 'white' ]]; then
        list_type='白'
        file_name='whitelist.txt'
    elif [[ $1 == 'black' ]]; then
        list_type='黑'
        file_name='blocklist.txt'
    else
        color_print error "edit_list() 错误参数: $1"
    fi
    color_print info "开始修改存档的${list_type}名单..."

    array=($(generate_list_from_dir -c))
    if [[ ${#array[@]} == 0 ]]; then color_print error '未找到存档!'; return; fi
    select_one info '请选择一个存档'
    declare -r cluster=$answer
    declare -r list_path="$KLEI_ROOT_DIR/$WORLDS_DIR/$cluster/$file_name"

    array=('添加 删除')
    select_one info '请选择'
    if [[ $answer == '添加' ]]; then
        if [[ ! -e $list_path ]]; then echo '' > $list_path; fi
        color_print info "存档 $cluster 当前的$list_type名单:"
        cat $list_path
        read -p '请输入玩家ID, 多个ID之间用空格隔开> ' array
        declare id
        for id in ${array[@]}; do
            if cat $list_path | grep -sq $id; then
                color_print warn "ID:${id}已存在于${list_type}名单"
            else
                echo $id >> $list_path
            fi
        done
    fi
    if [[ $answer == '删除' ]]; then
        if [[ ! -e $list_path ]]; then color_print warn "存档 $cluster 里未找到$list_type名单!请先添加!"; return; fi

        array=($(cat $list_path))
        multi_select info "请选择要从${list_type}名单删除的ID"
        declare delete_id
        for delete_id in ${array[@]}; do
            sed -i -e "s/^${delete_id}//g" $list_path
        done
    fi
    #sed -i -z -e 's/\n\+/\n/g' $list_path
    sed -i -e '/^$/d' $list_path

    color_print info "存档 $cluster 当前的$list_type名单:"
    cat $list_path
}
