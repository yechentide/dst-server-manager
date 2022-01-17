-- 注: lua里面要用中文当key的话, 得像这样 --> [[[中文]] ] 或者 ["中文"]
-- 由于dictionary的key是无序的, 所以这里用array来保存key的顺序
main_generations_table = {
    array = {"全局", "世界", "资源", "生物以及刷新点", "敌对生物以及刷新点"},
    ["全局"] = {
        array = {"起始季节"},
        ["起始季节"] = {
            en = "season_start",
            default = "default",
            type = "startseason"
        }
    },
    ["世界"] = {
        array = {"生物群落", "出生点", "世界大小", "分支", "环形", "试金石", "失败的冒险家", "开始资源多样化", "天体裂隙", "泰拉瑞亚"},
        ["生物群落"] = {
            en = "task_set",
            default = "default",
            type = "biomemain"
        },
        ["出生点"] = {
            en = "start_location",
            default = "default",
            type = "startlocationmain"
        },
        ["世界大小"] = {
            en = "world_size",
            default = "default",
            type = "worldsize"
        },
        ["分支"] = {
            en = "branching",
            default = "default",
            type = "branch"
        },
        ["环形"] = {
            en = "loop",
            default = "default",
            type = "loop"
        },
        ["试金石"] = {
            en = "touchstone",
            default = "default",
            type = "object02"
        },
        ["失败的冒险家"] = {
            en = "boons",
            default = "default",
            type = "object02"
        },
        ["开始资源多样化"] = {
            en = "prefabswaps_start",
            default = "default",
            type = "prefabswapsstart"
        },
        ["天体裂隙"] = {
            en = "moon_fissure",
            default = "default",
            type = "object02"
        },
        ["泰拉瑞亚"] = {
            en = "terrariumchest",
            default = "default",
            type = "spiderwarriors"
        }
    },
    ["资源"] = {
        array = {"草", "巨石", "月树", "树苗", "池塘", "浮堆", "海星", "温泉", "燧石", "芦苇", "蘑菇", "仙人掌", "尖灌木", "月亮石", "浆果丛", "胡萝卜", "风滚草", "公牛海带", "月亮树苗", "流星区域", "迷你冰川", "树(所有)", "石果灌木丛", "花，邪恶花", "海岸公牛海带"},
        ["草"] = {
            en = "grass",
            default = "default",
            type = "object02"
        },
        ["巨石"] = {
            en = "rock",
            default = "default",
            type = "object02"
        },
        ["月树"] = {
            en = "moon_tree",
            default = "default",
            type = "object02"
        },
        ["树苗"] = {
            en = "sapling",
            default = "default",
            type = "object02"
        },
        ["池塘"] = {
            en = "ponds",
            default = "default",
            type = "object02"
        },
        ["浮堆"] = {
            en = "ocean_seastack",
            default = "ocean_default",
            type = "objectocean"
        },
        ["海星"] = {
            en = "moon_starfish",
            default = "default",
            type = "object02"
        },
        ["温泉"] = {
            en = "moon_hotspring",
            default = "default",
            type = "object02"
        },
        ["燧石"] = {
            en = "flint",
            default = "default",
            type = "object02"
        },
        ["芦苇"] = {
            en = "reeds",
            default = "default",
            type = "object02"
        },
        ["蘑菇"] = {
            en = "mushroom",
            default = "default",
            type = "object02"
        },
        ["仙人掌"] = {
            en = "cactus",
            default = "default",
            type = "object02"
        },
        ["尖灌木"] = {
            en = "marshbush",
            default = "default",
            type = "object02"
        },
        ["月亮石"] = {
            en = "moon_rock",
            default = "default",
            type = "object02"
        },
        ["浆果丛"] = {
            en = "berrybush",
            default = "default",
            type = "object02"
        },
        ["胡萝卜"] = {
            en = "carrot",
            default = "default",
            type = "object02"
        },
        ["风滚草"] = {
            en = "tumbleweed",
            default = "default",
            type = "object02"
        },
        ["公牛海带"] = {
            en = "ocean_bullkelp",
            default = "default",
            type = "object02"
        },
        ["月亮树苗"] = {
            en = "moon_sapling",
            default = "default",
            type = "object02"
        },
        ["流星区域"] = {
            en = "meteorspawner",
            default = "default",
            type = "object02"
        },
        ["迷你冰川"] = {
            en = "rock_ice",
            default = "default",
            type = "object02"
        },
        ["树(所有)"] = {
            en = "trees",
            default = "default",
            type = "object02"
        },
        ["石果灌木丛"] = {
            en = "moon_berrybush",
            default = "default",
            type = "object02"
        },
        ["花，邪恶花"] = {
            en = "flowers",
            default = "default",
            type = "object02"
        },
        ["海岸公牛海带"] = {
            en = "moon_bullkelp",
            default = "default",
            type = "object02"
        }
    },
    ["生物以及刷新点"] = {
        array = {"兔洞", "猪屋", "秃鹫", "鱼群", "伏特羊", "鼹鼠洞", "龙虾窝", "沙拉蝾螈", "皮费娄牛", "空心树桩", "胡萝卜鼠", "蜜蜂蜂窝"},
        ["兔洞"] = {
            en = "rabbits",
            default = "default",
            type = "object02"
        },
        ["猪屋"] = {
            en = "pigs",
            default = "default",
            type = "object02"
        },
        ["秃鹫"] = {
            en = "buzzard",
            default = "default",
            type = "object02"
        },
        ["鱼群"] = {
            en = "ocean_shoal",
            default = "default",
            type = "object02"
        },
        ["伏特羊"] = {
            en = "lightninggoat",
            default = "default",
            type = "object02"
        },
        ["鼹鼠洞"] = {
            en = "moles",
            default = "default",
            type = "object02"
        },
        ["龙虾窝"] = {
            en = "ocean_wobsterden",
            default = "default",
            type = "object02"
        },
        ["沙拉蝾螈"] = {
            en = "moon_fruitdragon",
            default = "default",
            type = "object02"
        },
        ["皮费娄牛"] = {
            en = "beefalo",
            default = "default",
            type = "object02"
        },
        ["空心树桩"] = {
            en = "catcoon",
            default = "default",
            type = "object02"
        },
        ["胡萝卜鼠"] = {
            en = "moon_carrot",
            default = "default",
            type = "object02"
        },
        ["蜜蜂蜂窝"] = {
            en = "bees",
            default = "default",
            type = "object02"
        }
    },
    ["敌对生物以及刷新点"] = {
        array = {"海草", "触手", "猎犬丘", "蜘蛛巢", "高脚鸟", "发条装置", "海象营地", "杀人蜂蜂窝", "漏雨的小屋", "破碎蜘蛛洞"},
        ["海草"] = {
            en = "ocean_waterplant",
            default = "ocean_default",
            type = "objectocean"
        },
        ["触手"] = {
            en = "tentacles",
            default = "default",
            type = "object02"
        },
        ["猎犬丘"] = {
            en = "houndmound",
            default = "default",
            type = "object02"
        },
        ["蜘蛛巢"] = {
            en = "spiders",
            default = "default",
            type = "object02"
        },
        ["高脚鸟"] = {
            en = "tallbirds",
            default = "default",
            type = "object02"
        },
        ["发条装置"] = {
            en = "chess",
            default = "default",
            type = "object02"
        },
        ["海象营地"] = {
            en = "walrus",
            default = "default",
            type = "object02"
        },
        ["杀人蜂蜂窝"] = {
            en = "angrybees",
            default = "default",
            type = "object02"
        },
        ["漏雨的小屋"] = {
            en = "merm",
            default = "default",
            type = "object02"
        },
        ["破碎蜘蛛洞"] = {
            en = "moon_spiders",
            default = "default",
            type = "object02"
        }
    }
}

main_settings_table = {
    array = {"全局", "冒险家", "世界", "资源再生", "生物", "敌对生物", "巨兽"},
    ["全局"] = {
        array = {"活动", "春", "夏", "秋", "冬", "昼夜选项", "皮费娄牛交配频率", "坎普斯"},
        ["活动"] = {
            en = "specialevent",
            default = "default",
            type = "event"
        },
        ["春"] = {
            en = "spring",
            default = "default",
            type = "seasonlength"
        },
        ["夏"] = {
            en = "summer",
            default = "default",
            type = "seasonlength"
        },
        ["秋"] = {
            en = "autumn",
            default = "default",
            type = "seasonlength"
        },
        ["冬"] = {
            en = "winter",
            default = "default",
            type = "seasonlength"
        },
        ["昼夜选项"] = {
            en = "day",
            default = "default",
            type = "daytype"
        },
        ["皮费娄牛交配频率"] = {
            en = "beefaloheat",
            default = "default",
            type = "object01"
        },
        ["坎普斯"] = {
            en = "krampus",
            default = "default",
            type = "object01"
        }
    },
    ["冒险家"] = {
        array = {"额外起始资源", "季节起始物品", "防骚扰出生保护", "离开游戏后物品掉落", "启蒙怪兽", "理智怪兽"},
        ["额外起始资源"] = {
            en = "extrastartingitems",
            default = "default",
            type = "extrastartingitems"
        },
        ["季节起始物品"] = {
            en = "seasonalstartingitems",
            default = "default",
            type = "spiderwarriors"
        },
        ["防骚扰出生保护"] = {
            en = "spawnprotection",
            default = "default",
            type = "loop"
        },
        ["离开游戏后物品掉落"] = {
            en = "dropeverythingondespawn",
            default = "default",
            type = "drop"
        },
        ["启蒙怪兽"] = {
            en = "brightmarecreatures",
            default = "default",
            type = "object01"
        },
        ["理智怪兽"] = {
            en = "shadowcreatures",
            default = "default",
            type = "object01"
        }
    },
    ["世界"] = {
        array = {"雨", "狩猎", "野火", "闪电", "青蛙雨", "森林石化", "流星频率", "猎犬袭击", "追猎惊喜"},
        ["雨"] = {
            en = "weather",
            default = "default",
            type = "object01"
        },
        ["狩猎"] = {
            en = "hunt",
            default = "default",
            type = "object01"
        },
        ["野火"] = {
            en = "wildfires",
            default = "default",
            type = "object01"
        },
        ["闪电"] = {
            en = "lightning",
            default = "default",
            type = "object01"
        },
        ["青蛙雨"] = {
            en = "frograin",
            default = "default",
            type = "object01"
        },
        ["森林石化"] = {
            en = "petrification",
            default = "default",
            type = "petrification"
        },
        ["流星频率"] = {
            en = "meteorshowers",
            default = "default",
            type = "object01"
        },
        ["猎犬袭击"] = {
            en = "hounds",
            default = "default",
            type = "object01"
        },
        ["追猎惊喜"] = {
            en = "alternatehunt",
            default = "default",
            type = "object01"
        }
    },
    ["资源再生"] = {
        array = {"重生速度", "花", "月树", "盐堆", "多枝树", "常青树", "桦栗树", "胡萝卜"},
        ["重生速度"] = {
            en = "regrowth",
            default = "default",
            type = "regrowthspeed"
        },
        ["花"] = {
            en = "flowers_regrowth",
            default = "default",
            type = "regrowthspeed"
        },
        ["月树"] = {
            en = "moon_tree_regrowth",
            default = "default",
            type = "regrowthspeed"
        },
        ["盐堆"] = {
            en = "saltstack_regrowth",
            default = "default",
            type = "regrowthspeed"
        },
        ["多枝树"] = {
            en = "twiggytrees_regrowth",
            default = "never",
            type = "regrowthspeed"
        },
        ["常青树"] = {
            en = "evergreen_regrowth",
            default = "default",
            type = "regrowthspeed"
        },
        ["桦栗树"] = {
            en = "deciduoustree_regrowth",
            default = "default",
            type = "regrowthspeed"
        },
        ["胡萝卜"] = {
            en = "carrots_regrowth",
            default = "default",
            type = "regrowthspeed"
        }
    },
    ["生物"] = {
        array = {"猪", "鸟", "企鹅", "兔人", "兔子", "浣猫", "火鸡", "蜜蜂", "蝴蝶", "鱼群", "鼹鼠", "龙虾", "一角鲸", "草壁虎转化"},
        ["猪"] = {
            en = "pigs_setting",
            default = "default",
            type = "object01"
        },
        ["鸟"] = {
            en = "birds",
            default = "default",
            type = "object01"
        },
        ["企鹅"] = {
            en = "penguins",
            default = "default",
            type = "object01"
        },
        ["兔人"] = {
            en = "bunnymen_setting",
            default = "default",
            type = "object01"
        },
        ["兔子"] = {
            en = "rabbits_setting",
            default = "default",
            type = "object01"
        },
        ["浣猫"] = {
            en = "catcoons",
            default = "default",
            type = "object01"
        },
        ["火鸡"] = {
            en = "perd",
            default = "default",
            type = "object01"
        },
        ["蜜蜂"] = {
            en = "bees_setting",
            default = "default",
            type = "object01"
        },
        ["蝴蝶"] = {
            en = "butterfly",
            default = "default",
            type = "object01"
        },
        ["鱼群"] = {
            en = "fishschools",
            default = "default",
            type = "object01"
        },
        ["鼹鼠"] = {
            en = "moles_setting",
            default = "default",
            type = "object01"
        },
        ["龙虾"] = {
            en = "wobsters",
            default = "default",
            type = "object01"
        },
        ["一角鲸"] = {
            en = "gnarwail",
            default = "default",
            type = "object01"
        },
        ["草壁虎转化"] = {
            en = "grassgekkos",
            default = "never",
            type = "object01"
        }
    },
    ["敌对生物"] = {
        array = {"海象", "猎犬", "蚊子", "蜘蛛", "蝙蝠", "青蛙", "鱼人", "鱿鱼", "鲨鱼", "杀人蜂", "食人花", "恐怖猎犬", "月石企鹅", "破碎蜘蛛", "蜘蛛战士", "饼干切割机"},
        ["海象"] = {
            en = "walrus_setting",
            default = "default",
            type = "object01"
        },
        ["猎犬"] = {
            en = "hound_mounds",
            default = "default",
            type = "object01"
        },
        ["蚊子"] = {
            en = "mosquitos",
            default = "default",
            type = "object01"
        },
        ["蜘蛛"] = {
            en = "spiders_setting",
            default = "default",
            type = "object01"
        },
        ["蝙蝠"] = {
            en = "bats_setting",
            default = "default",
            type = "object01"
        },
        ["青蛙"] = {
            en = "frogs",
            default = "default",
            type = "object01"
        },
        ["鱼人"] = {
            en = "merms",
            default = "default",
            type = "object01"
        },
        ["鱿鱼"] = {
            en = "squid",
            default = "default",
            type = "object01"
        },
        ["鲨鱼"] = {
            en = "sharks",
            default = "default",
            type = "object01"
        },
        ["杀人蜂"] = {
            en = "wasps",
            default = "default",
            type = "object01"
        },
        ["食人花"] = {
            en = "lureplants",
            default = "default",
            type = "object01"
        },
        ["恐怖猎犬"] = {
            en = "mutated_hounds",
            default = "default",
            type = "object01"
        },
        ["月石企鹅"] = {
            en = "penguins_moon",
            default = "default",
            type = "object01"
        },
        ["破碎蜘蛛"] = {
            en = "moon_spider",
            default = "default",
            type = "object01"
        },
        ["蜘蛛战士"] = {
            en = "spider_warriors",
            default = "default",
            type = "object01"
        },
        ["饼干切割机"] = {
            en = "cookiecutters",
            default = "default",
            type = "object01"
        }
    },
    ["巨兽"] = {
        array = {"熊獾", "蜂后", "龙蝇", "克劳斯", "帝王蟹", "果蝇王", "邪天翁", "麋鹿鹅", "恐怖之眼", "树精守卫", "毒桦栗树", "独眼巨鹿", "蚁狮", "蜘蛛女王"},
        ["熊獾"] = {
            en = "bearger",
            default = "default",
            type = "object01"
        },
        ["蜂后"] = {
            en = "beequeen",
            default = "default",
            type = "object01"
        },
        ["龙蝇"] = {
            en = "dragonfly",
            default = "default",
            type = "object01"
        },
        ["克劳斯"] = {
            en = "klaus",
            default = "default",
            type = "object01"
        },
        ["帝王蟹"] = {
            en = "crabking",
            default = "default",
            type = "object01"
        },
        ["果蝇王"] = {
            en = "fruitfly",
            default = "default",
            type = "object01"
        },
        ["邪天翁"] = {
            en = "malbatross",
            default = "default",
            type = "object01"
        },
        ["麋鹿鹅"] = {
            en = "goosemoose",
            default = "default",
            type = "object01"
        },
        ["恐怖之眼"] = {
            en = "eyeofterror",
            default = "default",
            type = "object01"
        },
        ["树精守卫"] = {
            en = "liefs",
            default = "default",
            type = "object01"
        },
        ["毒桦栗树"] = {
            en = "deciduousmonster",
            default = "default",
            type = "object01"
        },
        ["独眼巨鹿"] = {
            en = "deerclops",
            default = "default",
            type = "object01"
        },
        ["蚁狮"] = {
            en = "antliontribute",
            default = "default",
            type = "object01"
        },
        ["蜘蛛女王"] = {
            en = "spiderqueen",
            default = "default",
            type = "object01"
        }
    }
}
