-- 注: lua里面要用中文当key的话, 得像这样 --> [[[中文]] ] 或者 ["中文"]a
-- 由于dictionary的key是无序的, 所以这里用array来保存key的顺序

-- 以下table里面的type, 指定了ini_value_types.lua里面的key
-- 但有几个例外:
--      string              -->     由用户直接输入(不可为空)
--      port                -->     2000~65535的数字

shard_table = {
    array = {"监听端口", "是否为主世界", "shard名", "encode_user_path", "master_server_port", "authentication_port"},
    ["监听端口"] = {
        en = "server_port",
        value = "11000",
        description = "监听连接的UDP端口。同一主机上各分片的端口设置需不同。要让服务器在公共服务器列表页显示，此端口取值范围应是10998~11018。",
        type = "port"
    },
    ["是否为主世界"] = {
        en = "is_master",
        value = "false",
        description = "将一个shard设为主世界。每个存档里必须只有一个主世界shard。在主世界shard的server.ini中设置此项为true，其他shard中设为false",
        type = "bool"
    },
    ["shard名"] = {
        en = "name",
        value = "shard-name",
        description = "在shard_enabled = true, is_master = false时，必须配置",
        type = "string"
    },
    ["encode_user_path"] = {
        en = "encode_user_path",
        value = "true",
        description = "暂无说明",
        type = "bool"
    },
    ["master_server_port"] = {
        en = "master_server_port",
        value = "27018",
        description = "steam使用的内部端口。同一机器上每个分片服务器，此端口设定不能为同一个。",
        type = "port"
    },
    ["authentication_port"] = {
        en = "authentication_port",
        value = "8768",
        description = "steam使用的内部端口。同一机器上每个分片服务器，此端口设定不能为同一个。",
        type = "port"
    }
}
