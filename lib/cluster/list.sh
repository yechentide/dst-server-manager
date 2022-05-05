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

    declare -a array=($(generate_cluster_list -c $KLEI_ROOT_DIR $WORLDS_DIR_NAME))
    if [[ ${#array[@]} == 0 ]]; then color_print error '未找到存档!'; return; fi
    
    declare cluster=''
    rm $ARRAY_PATH
    for cluster in ${array[@]}; do echo $cluster >> $ARRAY_PATH; done
    selector -cq info '请选择一个存档'
    cluster=$(cat $ANSWER_PATH)
    if [[ $cluster == '返回' ]]; then return 0; fi

    declare -r list_path="$KLEI_ROOT_DIR/$WORLDS_DIR_NAME/$cluster/$file_name"

    array=('添加 删除')
    declare answer=''
    rm $ARRAY_PATH
    for answer in ${array[@]}; do echo $answer >> $ARRAY_PATH; done
    selector -cq info '请选择'
    answer=$(cat $ANSWER_PATH)
    if [[ $answer == '返回' ]]; then return 0; fi

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
        sed -i -e '/^$/d' $list_path
        if [[ ! -s $list_path ]]; then
            color_print warn "$list_type名单为空!"
            return 0
        fi

        unset array
        declare -a array=($(cat $list_path))
        declare delete_id
        rm $ARRAY_PATH
        for delete_id in ${array[@]}; do echo $delete_id >> $ARRAY_PATH; done

        selector -cmq info "请选择要从${list_type}名单删除的ID"
        unset array
        declare -a array=$(cat $ANSWER_PATH)
        if echo $array | grep -sq '返回'; then return 0; fi

        for delete_id in ${array[@]}; do
            sed -i -e "s/^${delete_id}//g" $list_path
        done
    fi
    sed -i -e '/^$/d' $list_path

    color_print info "存档 $cluster 当前的$list_type名单:"
    cat $list_path
}
