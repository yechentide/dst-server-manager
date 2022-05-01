#######################################
# 作用: 让用户输入要下载的模组ID
# 返回:
#   ID的数组   储存在全局变量array
#######################################
function get_mods_id_from_input() {
    declare -a result=()
    color_print info '请输入想要下载的模组ID, 多个ID请用空格隔开'
    while true; do
        read -p '> ' answer
        declare item=''
        for item in ${answer[@]}; do
            if [[ ! $item =~ ^[0-9]+$ ]] || [[ $item -le 0 ]]; then
                color_print warn "请输入正确数字。错误输入将被无视: $item"
                continue
            fi
            result+=($item)
        done
        if [[ ${#result[@]} -gt 0 ]]; then break; fi
    done
    array=(${result[@]})
    #color_print info "输入的ID: ${result[*]}"
}

function add_mods_to_setting_file() {
    declare flag=1
    declare -a list=$(generate_mod_id_list_from_setting_file)
    declare id=''
    # show installed mods' name
    color_print info '以下是已经下载的模组:'
    for id in ${list[@]}; do
        echo -n "ID: $id      "
        get_mod_name_from_modinfo "$REPO_ROOT_DIR/.cache/modinfo/$id.lua"
    done

    get_mods_id_from_input
    for id in ${array[@]}; do
        if echo "${list[@]}" | grep -sq $id; then
            color_print warn "ID $id 已存在!"
            continue
        fi
        # 国内会被墙...
        #if [[ $(is_dst_mod $id) == 'no' ]]; then
        #    color_print error "ID $id 不是饥荒联机版的Mod"
        #    continue
        #fi
        color_print info "添加Mod: $id"
        echo "ServerModSetup(\"${id}\")" >> "$V1_MOD_DIR/dedicated_server_mods_setup.lua"
        flag=0
    done
    if [[ $flag == 0 ]]; then return 0; else return 1; fi
}
