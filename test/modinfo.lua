name = "防卡两招(Antistun)"
description = "能够把掉落物自动堆叠，同时定期清理服务器。抄自『河蟹防熊锁』。"
author = "大大果汁"
version = "1.0.7"
forumthread = ""
api_version = 10
icon_atlas = "modicon.xml"
icon = "modicon.tex"
dont_starve_compatible = true
reign_of_giants_compatible = true
shipwrecked_compatible = false
dst_compatible = true
client_only_mod = false
all_clients_require_mod = true
server_filter_tags = {"stack", "clean"}

configuration_options =
{
    {
        name = "stack",
        label = "自动堆叠(Stacking)",
        options =
        {
            {description = "开", data = true, hover = [[掉落相同的物品会 boom 的一声堆叠起来。
            Auto stack the same loots.]]},
            {description = "关", data = false, hover = "啥事儿都不发生。Nothing will happen."},
        },
        default = true,
    },
    {
        name = "clean",
        label = "自动清理(Cleaning)",
        options =
        {
            {description = "开", data = true, hover = [[每过 10 天自动清理服务器无用物品。
            All servers clean every 10 days]]},
            {description = "关", data = false, hover = "啥事儿都不发生。Nothing will happen."},
        },
        default = true,
    },
    {
        name = "lang",
        label = "语言(Language)",
        options =
        {
            {description = "中文", data = true},
            {description = "English", data = false},
        },
        default = true,
    },
}