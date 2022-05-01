function update_server() {
    color_print warn '升级服务端之前，将会关闭所有运行中的世界！'
    yes_or_no warn '是否关闭所有运行中的世界, 并更新服务端？'
    if [[ $answer == 'no' ]]; then
        color_print -n info '取消升级 '; count_down -d 3
        return 0
    fi

    # To Fix: 升级服务端会导致dedicated_server_mods_setup.lua被清空, 然后Mod会无效
    mv $V1_MOD_DIR/dedicated_server_mods_setup.lua $V1_MOD_DIR/dedicated_server_mods_setup.lua.bak

    stop_all_shard
    color_print info "开始升级服务端..."
    color_print -n info '根据网络状况，更新可能会很耗时间，更新完成为止请勿息屏 '; count_down 3
    ~/Steam/steamcmd.sh +force_install_dir $DST_ROOT_DIR +login anonymous +app_update 343050 validate +quit

    mv $V1_MOD_DIR/dedicated_server_mods_setup.lua.bak $V1_MOD_DIR/dedicated_server_mods_setup.lua

    if [[ $? ]]; then
        color_print success '饥荒服务端更新完成!';
        color_print info '途中可能会出现Failed to init SDL priority manager: SDL not found警告'
        color_print info '不用担心, 这个不影响下载/更新DST'
        color_print -n info '虽然可以解决, 但这需要下载一堆依赖包, 有可能会对其他运行中的服务造成影响, 所以无视它吧～ '; count_down -d 6
    else
        color_print error '似乎出现了什么错误...'
        yes_or_no info '再试一次？'
        if [[ $answer == 'yes' ]]; then
            update_server
        fi
    fi
}
