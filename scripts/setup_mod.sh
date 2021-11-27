function configure_mods() {
    # todo
    echo 'setup mods'
}
function add_mods() {
    while true; do
        echo ''
        echo '空着或者输入0并按回车结束'
        read -p '请输入mod编号 > ' MOD_ID
        if [[ ${#MOD_ID} == 0 || $MOD_ID == '0' ]]; then break; fi

        if [[ "$MOD_ID" =~ ^[0-9]+$ ]]; then
            echo "ServerModSetup(\"${MOD_ID}\")" >> $DST_ROOT_DIR/mods/dedicated_server_mods_setup.lua
            sed "2i \    [\"workshop-${MOD_ID}\"]={ configuration_options={  }, enabled=true }," mod.lua
            echo "成功添加mod - ${MOD_ID}"
        else
            echo "输入错误: $MOD_ID, mod编号必须为数字"
        fi
    done
}