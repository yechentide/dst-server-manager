#!/usr/bin/env bash
set -eu
echo '请不要执行本文件'
exit 1

$HOME
│
├── DSTManager.sh           # <-- 需要上传的脚本(也可以用命令直接从仓库下载)
│
├── $repo_root_dir          # <-- 脚本仓库，包含各种配置文件模板
│   ├── docs                # <-- 描述了各个文件都放在哪里, 还放了一些示例图片
│   ├── scripts             # <-- 脚本
│   └── templates           # <-- 配置文件模板
│
├── $dst_root_dir
│   ├── bin
│   │   └── dontstarve_dedicated_server_nullrenderer        # <-- 32位服务端
│   ├── bin64
│   │   └── dontstarve_dedicated_server_nullrenderer_x64    # <-- 64位服务端
│   └── mods
│       └── dedicated_server_mods_setup.lua                 # <-- 在这边添加服务端mod
│
├── Steam
│   └── steamcmd.sh                                         # <-- 下载，更新饥荒用这个
│
└── $klei_root_dir
    ├── Agreements
    └── $worlds_dir
        └── 存档名字(由玩家输入)
            ├── cluster.ini
            ├── cluster_token.txt                           # <-- token放这里
            ├── $shard_main_name
            │   ├── worldgenoverride.lua                    # <-- 地上世界设置是这
            │   ├── modoverrides.lua                        # <-- 地上地底的modoverrides.lua的内容一模一样
            │   └── server.ini
            └── $shard_cave_name
                ├── worldgenoverride.lua                    # <-- 地底世界设置是这
                ├── modoverrides.lua                        # <-- 地上地底的modoverrides.lua的内容一模一样
                └── server.ini

# 以下为本脚本的默认设定

`/home/username`
│
├── DSTManager.sh           # <-- 需要上传的脚本(也可以用命令直接从仓库下载)
│
├── `DSTServerManager`      # <-- 脚本仓库，包含各种配置文件模板
│   ├── docs                # <-- 描述了各个文件都放在哪里, 还放了一些示例图片
│   ├── scripts             # <-- 脚本
│   └── templates           # <-- 配置文件模板
│
├── `Server`
│   ├── bin
│   │   └── dontstarve_dedicated_server_nullrenderer        # <-- 32位服务端
│   ├── bin64
│   │   └── dontstarve_dedicated_server_nullrenderer_x64    # <-- 64位服务端
│   └── mods
│       └── dedicated_server_mods_setup.lua                 # <-- 在这边添加服务端mod
│
├── Steam
│   └── steamcmd.sh                                         # <-- 下载，更新饥荒用这个
│
└── `Klei`
    ├── Agreements
    └── `worlds`
        └── 存档名字(由玩家输入)
            ├── cluster.ini
            ├── cluster_token.txt                           # <-- token放这里
            ├── `Main`      # <-- 地上世界的文件夹名字, 一般是Master
            │   ├── worldgenoverride.lua                    # <-- 地上世界设置是这
            │   ├── modoverrides.lua                        # <-- 地上地底的modoverrides.lua的内容一模一样
            │   └── server.ini
            └── `Cave`
                ├── worldgenoverride.lua                    # <-- 地底世界设置是这
                ├── modoverrides.lua                        # <-- 地上地底的modoverrides.lua的内容一模一样
                └── server.ini
