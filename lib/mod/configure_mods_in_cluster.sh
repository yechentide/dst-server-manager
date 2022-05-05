# Parameters:
#   $1: 'add' / 'update'
function configure_mods_in_cluster() {
    declare -r installed_mods=$(show_mods_list -i $V1_MOD_DIR $V2_MOD_DIR $UGC_DIR)
    if [[ ${#installed_mods} == 0 ]]; then color_print warn '未找到任何mod! 请先下载...'; return 0; fi
    
    declare -a array=$(generate_cluster_list -c $KLEI_ROOT_DIR $WORLDS_DIR_NAME)
    if [[ ${#array} == 0 ]]; then color_print error '未找到存档!'; return 0; fi

    declare answer=''
    rm $ARRAY_PATH
    for answer in ${array[@]}; do echo $answer >> $ARRAY_PATH; done
    selector -cq info '请选择要配置Mod的存档'
    answer=$(cat $ANSWER_PATH)
    if echo $answer | grep -sq '返回'; then return 0; fi

    declare -a mod_file_list=($(find $KLEI_ROOT_DIR/$WORLDS_DIR_NAME/$answer -type f -name modoverrides.lua))
    if [[ ${#mod_file_list} == 0 ]]; then color_print error '未找到modoverrides.lua!'; return 0; fi
    if [[ $1 == 'update' ]] && ! cat ${mod_file_list[0]} | grep -sq "\[\"workshop-"; then
        color_print warn '请先给该存档添加Mod!'
        return 0
    fi

    declare -r tmp_path="$REPO_ROOT_DIR/.cache/modoverrides.lua"
    cp ${mod_file_list[0]} $tmp_path
    lua $REPO_ROOT_DIR/bin/editor/mod_manager.lua $REPO_ROOT_DIR $1 $V1_MOD_DIR $V2_MOD_DIR

    declare path
    for path in ${mod_file_list[@]}; do
        cp $tmp_path $path
    done
    rm $tmp_path
}
