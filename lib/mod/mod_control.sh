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

#######################################
# 作用: 确认是不是DST的模组。国内会被墙导致卡住
# 参数:
#   $1: mod id
# 输出:
#   'yes' / 'no'
#######################################
function is_dst_mod() {
    if wget -O - "https://steamcommunity.com/sharedfiles/filedetails/?id=$1" 2>&1 | grep -sq "Don't Starve Together"; then
        echo 'yes'
    else
        echo 'no'
    fi
}
