#remove-from-cluster
#remove-from-file
#remove-dir
function delete_mods() {
    show_mods_list $V1_MOD_DIR $V2_MOD_DIR $UGC_DIR
    show_mods_list -a $V1_MOD_DIR $V2_MOD_DIR $UGC_DIR > $ARRAY_PATH
    declare -r all_mods_dir=$(get_all_mods_dir $V1_MOD_DIR $V2_MOD_DIR)

    # 从dedicated_server_mods_setup.lua删除这个mod
    selector -cmq info '请选择要删除的模组ID'
    declare -a array=$(cat $ANSWER_PATH)
    if echo $array | grep -sq '返回'; then return 0; fi

    declare -a delete_mods_list=(${array[@]})
    declare -r file_path="$V1_MOD_DIR/dedicated_server_mods_setup.lua"
    declare target_mod_id=''
    for target_mod_id in ${delete_mods_list[@]}; do
        sed -i "/^ServerModSetup(\"$target_mod_id\")/d" $file_path
        # 删除mod文件夹
        declare all_path=$(echo "$all_mods_dir" | grep -s "/$target_mod_id")
        echo "delete: $all_path"
        declare path=''
        for path in ${all_path[@]}; do
            if [[ -e $path ]]; then rm -rf $path; fi
        done
    done

    # 从所有存档里删除这个mod
    array=$(generate_cluster_list -c $KLEI_ROOT_DIR $WORLDS_DIR_NAME)
    if [[ ${#array} == 0 ]]; then return 0; fi

    declare -r tmp_path="$REPO_ROOT_DIR/.cache/modoverrides.lua"
    declare cluster=''
    for cluster in ${array[@]}; do
        declare -a mod_file_list=($(find $KLEI_ROOT_DIR/$WORLDS_DIR_NAME/$cluster -type f -name modoverrides.lua))
        if [[ ${#mod_file_list} == 0 ]]; then continue; fi                          # 存档里没有mod配置文件的话跳过
        if ! cat ${mod_file_list[0]} | grep -sq "\[\"workshop-"; then continue; fi  # mod配置文件里没有配置的话跳过

        cp ${mod_file_list[0]} $tmp_path
        lua $REPO_ROOT_DIR/bin/editor/mod_manager.lua $REPO_ROOT_DIR delete "${delete_mods_list[@]}"
        declare path=''
        for path in ${mod_file_list[@]}; do
            cp $tmp_path $path
        done
        rm $tmp_path
    done
}
