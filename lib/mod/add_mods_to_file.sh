#######################################
# 作用: 让用户输入要下载的模组ID
# 返回:
#   ID的数组   储存在answer文件里
#######################################
function get_mods_id_from_input() {
    if [[ -e $ANSWER_PATH ]]; then rm $ANSWER_PATH; fi
    color_print info '请输入想要下载的模组ID, 多个ID请用空格隔开'
    while true; do
        read -p '> ' answer
        declare item=''
        for item in ${answer[@]}; do
            if [[ ! $item =~ ^[0-9]+$ ]] || [[ $item -le 0 ]]; then
                color_print warn "请输入正确数字。错误输入将被无视: $item"
                continue
            fi
            echo $item >> $ANSWER_PATH
        done
        if [[ -e $ANSWER_PATH ]]; then
            sed -i -e '/^$/d' $ANSWER_PATH
            if [[ -s $ANSWER_PATH ]]; then break; fi
        fi
    done
}

function add_mods_to_file() {
    declare flag=1
    declare id=''
    declare -a list=$(generate_installed_mod_list $V1_MOD_DIR)

    show_mods_list $V1_MOD_DIR $V2_MOD_DIR $UGC_DIR

    get_mods_id_from_input
    declare -a array=$(cat $ANSWER_PATH)
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
