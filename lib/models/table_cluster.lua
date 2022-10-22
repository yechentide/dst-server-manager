-- 注: lua里面要用中文当key的话, 得像这样 --> [[[中文]] ] 或者 ["中文"]a
-- 由于dictionary的key是无序的, 所以这里用array来保存key的顺序

-- 以下table里面的type, 指定了ini_value_types.lua里面的key
-- 但有几个例外:
--      string              -->     由用户直接输入(不可为空)
--      zero_string         -->     由用户直接输入(空值ok)
--      positive_number     -->     大于0的数字
--      ipv4                -->     IPv4地址
--      port                -->     2000~65535的数字

cluster_table = {
    array = {"服务器名", "服务器介绍", "服务器密码", "服务器语言", "玩家上限", "开启PVP", "无人暂停", "开启投票", "开启控制台", "最大快照数", "是否有多个shard", "bind_ip", "master_ip", "master_port"},
    ["服务器名"] = {
        key = "cluster_name",
        value = "鸽子们的摸鱼日常",
        description = "服务器名称，在公共房间列表中将显示此名称。",
        type = "string"
    },
    ["服务器介绍"] = {
        key = "cluster_description",
        value = "咕咕咕!",
        description = "服务器描述。在公共房间列表中，服务器详细信息一栏将显示设定的内容。",
        type = "zero_string"
    },
    ["服务器密码"] = {
        key = "cluster_password",
        value = "",
        description = "玩家进入服务器时所输入的密码。如果不需要密码，将此项留空或忽略设置即可。",
        type = "zero_string"
    },
    ["服务器语言"] = {
        key = "cluster_language",
        value = "zh",
        description = "语言设置",
        type = "language"
    },
    -- ["游戏风格"] = {
    --     key = "cluster_intention",
    --     value = "cooperative",
    --     description = "游戏风格。合作, 竞赛, 休闲, 疯狂。",
    --     type = "intention"
    -- },
    -- ["游戏模式"] = {
    --     key = "game_mode",
    --     value = "endless",
    --     description = "游戏模式。生存, 无尽, 荒野。本脚本不支持熔炉和暴食。",
    --     type = "mode"
    -- },
    ["玩家上限"] = {
        key = "max_players",
        value = "6",
        description = "可用同时连接服务器的玩家数量。",
        type = "positive_number"
    },
    ["开启PVP"] = {
        key = "pvp",
        value = "false",
        description = "设置为true时, 打开pvp功能",
        type = "bool"
    },
    ["无人暂停"] = {
        key = "pause_when_empty",
        value = "true",
        description = "设置为true时，当服务器中无玩家，暂停服务器时间流逝。",
        type = "bool"
    },
    ["开启投票"] = {
        key = "vote_enabled",
        value = "true",
        description = "设置为true时, 打开玩家投票功能。",
        type = "bool"
    },
    ["开启控制台"] = {
        key = "console_enabled",
        value = "true",
        description = "允许在游戏控制台或正在运行的server终端中输入命令",
        type = "bool"
    },
    ["最大快照数"] = {
        key = "max_snapshots",
        value = "6",
        description = "快照留存最大值。每次存档会生成一个快照，用于回滚游戏。游戏默认存档动作在天刚亮的时候执行。",
        type = "positive_number"
    },
    ["是否有多个shard"] = {
        key = "shard_enabled",
        value = "true",
        description = "是否共享服务器。搭建多层世界(包括1地面1洞穴)，此配置项必须设置为true。单层世界可以忽略。",
        type = "bool"
    },
    ["bind_ip"] = {
        key = "bind_ip",
        value = "127.0.0.1",
        description = "bind_ip指定了主服务器监听分片服务器连接请求的网络地址。",
        type = "ipv4"
    },
    ["master_ip"] = {
        key = "master_ip",
        value = "127.0.0.1",
        description = "未配置主服务器的分片服务器，将尝试使用此IP地址连接主服务器。",
        type = "ipv4"
    },
    ["master_port"] = {
        key = "master_port",
        value = "10888",
        description = "主服务器对此UDP端口保持监听状态，未配置主服务器的分片服务器将使用此端口连接主服务器。",
        type = "port"
    }
}