Initfiles函数是用来生成各种模板文件

觉得不错的功能：
周期性检查游戏进程是否意外退出，退出自动重启  keepalive
周期性备份当前开启的存档  backupcluster
周期性检查游戏是否有更新，有则重启更新！  gameupdate
服务端后台功能（需要在开启服务端时风格窗口）
脚本更新功能


[17]删除Steam缓存(游戏更新失败修复使用)   Remove_steam_cache
Remove_steam_cache(){
  rm -rf ${HOME}/Steam >/dev/null 2>&1
  info "安装缓存清理完毕！"
}

