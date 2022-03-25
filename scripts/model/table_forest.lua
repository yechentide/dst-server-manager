-- 注: lua里面要用中文当key的话, 得像这样 --> [[[中文]] ] 或者 ["中文"]
-- 由于dictionary的key是无序的, 所以这里用array来保存key的顺序

-- 以下table里面的type, 指定了world_value_types.lua里面的key

forest_generations_table = {
    array = {"全局", "世界", "资源", "生物以及刷新点", "敌对生物以及刷新点"},
    ["全局"] = {
        array = {"起始季节"},
        ["起始季节"] = {
            en = "season_start",
            value = "default",
            type = "startseason"
        }
    },
    ["世界"] = {
        array = {"生物群落", "出生点", "世界大小", "分支", "环形", "道路", "试金石", "失败的冒险家", "开始资源多样化", "天体裂隙", "盒中泰拉"},
        ["生物群落"] = {
            en = "task_set",
            value = "default",
            type = "biomeforest"
        },
        ["出生点"] = {
            en = "start_location",
            value = "default",
            type = "startlocationforest"
        },
        ["世界大小"] = {
            en = "world_size",
            value = "default",
            type = "worldsize"
        },
        ["分支"] = {
            en = "branching",
            value = "default",
            type = "branch"
        },
        ["环形"] = {
            en = "loop",
            value = "default",
            type = "loop"
        },
        ["道路"] = {
            en = "roads",
            value = "default",
            type = "defaultnever"
        },
        ["试金石"] = {
            en = "touchstone",
            value = "default",
            type = "options8"
        },
        ["失败的冒险家"] = {
            en = "boons",
            value = "default",
            type = "options8"
        },
        ["开始资源多样化"] = {
            en = "prefabswaps_start",
            value = "default",
            type = "prefabswapsstart"
        },
        ["天体裂隙"] = {
            en = "moon_fissure",
            value = "default",
            type = "options8"
        },
        ["盒中泰拉"] = {
            en = "terrariumchest",
            value = "default",
            type = "defaultnever"
        }
    },
    ["资源"] = {
        array = {"草", "巨石", "月树", "树苗", "池塘", "浮堆", "海星", "温泉", "燧石", "芦苇", "蘑菇", "仙人掌", "尖灌木", "月亮石", "浆果丛", "胡萝卜", "风滚草", "公牛海带", "月亮树苗", "流星区域", "迷你冰川", "树(所有)", "石果灌木丛", "花，邪恶花", "海岸公牛海带"},
        ["草"] = {
            en = "grass",
            value = "default",
            type = "options8"
        },
        ["巨石"] = {
            en = "rock",
            value = "default",
            type = "options8"
        },
        ["月树"] = {
            en = "moon_tree",
            value = "default",
            type = "options8"
        },
        ["树苗"] = {
            en = "sapling",
            value = "default",
            type = "options8"
        },
        ["池塘"] = {
            en = "ponds",
            value = "default",
            type = "options8"
        },
        ["浮堆"] = {
            en = "ocean_seastack",
            value = "ocean_default",
            type = "oceanoptions"
        },
        ["海星"] = {
            en = "moon_starfish",
            value = "default",
            type = "options8"
        },
        ["温泉"] = {
            en = "moon_hotspring",
            value = "default",
            type = "options8"
        },
        ["燧石"] = {
            en = "flint",
            value = "default",
            type = "options8"
        },
        ["芦苇"] = {
            en = "reeds",
            value = "default",
            type = "options8"
        },
        ["蘑菇"] = {
            en = "mushroom",
            value = "default",
            type = "options8"
        },
        ["仙人掌"] = {
            en = "cactus",
            value = "default",
            type = "options8"
        },
        ["尖灌木"] = {
            en = "marshbush",
            value = "default",
            type = "options8"
        },
        ["月亮石"] = {
            en = "moon_rock",
            value = "default",
            type = "options8"
        },
        ["浆果丛"] = {
            en = "berrybush",
            value = "default",
            type = "options8"
        },
        ["胡萝卜"] = {
            en = "carrot",
            value = "default",
            type = "options8"
        },
        ["风滚草"] = {
            en = "tumbleweed",
            value = "default",
            type = "options8"
        },
        ["公牛海带"] = {
            en = "ocean_bullkelp",
            value = "default",
            type = "options8"
        },
        ["月亮树苗"] = {
            en = "moon_sapling",
            value = "default",
            type = "options8"
        },
        ["流星区域"] = {
            en = "meteorspawner",
            value = "default",
            type = "options8"
        },
        ["迷你冰川"] = {
            en = "rock_ice",
            value = "default",
            type = "options8"
        },
        ["树(所有)"] = {
            en = "trees",
            value = "default",
            type = "options8"
        },
        ["石果灌木丛"] = {
            en = "moon_berrybush",
            value = "default",
            type = "options8"
        },
        ["花，邪恶花"] = {
            en = "flowers",
            value = "default",
            type = "options8"
        },
        ["海岸公牛海带"] = {
            en = "moon_bullkelp",
            value = "default",
            type = "options8"
        }
    },
    ["生物以及刷新点"] = {
        array = {"兔洞", "猪屋", "秃鹫", "鱼群", "伏特羊", "鼹鼠洞", "龙虾窝", "沙拉蝾螈", "皮费娄牛", "空心树桩", "胡萝卜鼠", "蜜蜂蜂窝"},
        ["兔洞"] = {
            en = "rabbits",
            value = "default",
            type = "options8"
        },
        ["猪屋"] = {
            en = "pigs",
            value = "default",
            type = "options8"
        },
        ["秃鹫"] = {
            en = "buzzard",
            value = "default",
            type = "options8"
        },
        ["鱼群"] = {
            en = "ocean_shoal",
            value = "default",
            type = "options8"
        },
        ["伏特羊"] = {
            en = "lightninggoat",
            value = "default",
            type = "options8"
        },
        ["鼹鼠洞"] = {
            en = "moles",
            value = "default",
            type = "options8"
        },
        ["龙虾窝"] = {
            en = "ocean_wobsterden",
            value = "default",
            type = "options8"
        },
        ["沙拉蝾螈"] = {
            en = "moon_fruitdragon",
            value = "default",
            type = "options8"
        },
        ["皮费娄牛"] = {
            en = "beefalo",
            value = "default",
            type = "options8"
        },
        ["空心树桩"] = {
            en = "catcoon",
            value = "default",
            type = "options8"
        },
        ["胡萝卜鼠"] = {
            en = "moon_carrot",
            value = "default",
            type = "options8"
        },
        ["蜜蜂蜂窝"] = {
            en = "bees",
            value = "default",
            type = "options8"
        }
    },
    ["敌对生物以及刷新点"] = {
        array = {"海草", "触手", "猎犬丘", "蜘蛛巢", "高脚鸟", "发条装置", "海象营地", "杀人蜂蜂窝", "漏雨的小屋", "破碎蜘蛛洞"},
        ["海草"] = {
            en = "ocean_waterplant",
            value = "ocean_default",
            type = "oceanoptions"
        },
        ["触手"] = {
            en = "tentacles",
            value = "default",
            type = "options8"
        },
        ["猎犬丘"] = {
            en = "houndmound",
            value = "default",
            type = "options8"
        },
        ["蜘蛛巢"] = {
            en = "spiders",
            value = "default",
            type = "options8"
        },
        ["高脚鸟"] = {
            en = "tallbirds",
            value = "default",
            type = "options8"
        },
        ["发条装置"] = {
            en = "chess",
            value = "default",
            type = "options8"
        },
        ["海象营地"] = {
            en = "walrus",
            value = "default",
            type = "options8"
        },
        ["杀人蜂蜂窝"] = {
            en = "angrybees",
            value = "default",
            type = "options8"
        },
        ["漏雨的小屋"] = {
            en = "merm",
            value = "default",
            type = "options8"
        },
        ["破碎蜘蛛洞"] = {
            en = "moon_spiders",
            value = "default",
            type = "options8"
        }
    }
}

forest_settings_table = {
    array = {"全局", "活动", "冒险家", "世界", "资源再生", "生物", "敌对生物", "巨兽"},
    ["全局"] = {
        array = {"活动", "春", "夏", "秋", "冬", "昼夜选项", "皮费娄牛交配频率", "坎普斯"},
        ["活动"] = {
            en = "specialevent",
            value = "default",
            type = "event"
        },
        ["春"] = {
            en = "spring",
            value = "default",
            type = "seasonlength"
        },
        ["夏"] = {
            en = "summer",
            value = "default",
            type = "seasonlength"
        },
        ["秋"] = {
            en = "autumn",
            value = "default",
            type = "seasonlength"
        },
        ["冬"] = {
            en = "winter",
            value = "default",
            type = "seasonlength"
        },
        ["昼夜选项"] = {
            en = "day",
            value = "default",
            type = "daytype"
        },
        ["皮费娄牛交配频率"] = {
            en = "beefaloheat",
            value = "default",
            type = "options5"
        },
        ["坎普斯"] = {
            en = "krampus",
            value = "default",
            type = "options5"
        }
    },
    ["活动"] = {
        array = {"盛夏鸭年华", "万圣夜", "冬季盛宴", "火鸡之年", "座狼之年", "猪王之年", "胡萝卜鼠之年", "皮弗娄牛之年", "浣猫之年"},
        ["盛夏鸭年华"] = {
            en = "crow_carnival",
            value = "default",
            type = "specificevent"
        },
        ["万圣夜"] = {
            en = "hallowed_nights",
            value = "default",
            type = "specificevent"
        },
        ["冬季盛宴"] = {
            en = "winters_feast",
            value = "default",
            type = "specificevent"
        },
        ["火鸡之年"] = {
            en = "year_of_the_gobbler",
            value = "default",
            type = "specificevent"
        },
        ["座狼之年"] = {
            en = "year_of_the_varg",
            value = "default",
            type = "specificevent"
        },
        ["猪王之年"] = {
            en = "year_of_the_pig",
            value = "default",
            type = "specificevent"
        },
        ["胡萝卜鼠之年"] = {
            en = "year_of_the_carrat",
            value = "default",
            type = "specificevent"
        },
        ["皮弗娄牛之年"] = {
            en = "year_of_the_beefalo",
            value = "default",
            type = "specificevent"
        },
        ["浣猫之年"] = {
            en = "year_of_the_catcoon",
            value = "default",
            type = "specificevent"
        },
    },
    ["冒险家"] = {
        array = {"额外起始资源", "季节起始物品", "防骚扰出生保护", "离开游戏后物品掉落", "启蒙怪兽", "理智怪兽"},
        ["额外起始资源"] = {
            en = "extrastartingitems",
            value = "default",
            type = "extrastartingitems"
        },
        ["季节起始物品"] = {
            en = "seasonalstartingitems",
            value = "default",
            type = "defaultnever"
        },
        ["防骚扰出生保护"] = {
            en = "spawnprotection",
            value = "default",
            type = "loop"
        },
        ["离开游戏后物品掉落"] = {
            en = "dropeverythingondespawn",
            value = "default",
            type = "defaultalways"
        },
        ["启蒙怪兽"] = {
            en = "brightmarecreatures",
            value = "default",
            type = "options5"
        },
        ["理智怪兽"] = {
            en = "shadowcreatures",
            value = "default",
            type = "options5"
        }
    },
    ["世界"] = {
        array = {"猎犬袭击", "冰猎犬群", "火猎犬群", "雨", "狩猎", "野火", "闪电", "青蛙雨", "森林石化", "流星频率", "追猎惊喜"},
        ["猎犬袭击"] = {
            en = "hounds",
            value = "default",
            type = "options5"
        },
        ["冰猎犬群"] = {
            en = "winterhounds",
            value = "default",
            type = "defaultnever"
        },
        ["火猎犬群"] = {
            en = "summerhounds",
            value = "default",
            type = "defaultnever"
        },
        ["雨"] = {
            en = "weather",
            value = "default",
            type = "options5"
        },
        ["狩猎"] = {
            en = "hunt",
            value = "default",
            type = "options5"
        },
        ["野火"] = {
            en = "wildfires",
            value = "default",
            type = "options5"
        },
        ["闪电"] = {
            en = "lightning",
            value = "default",
            type = "options5"
        },
        ["青蛙雨"] = {
            en = "frograin",
            value = "default",
            type = "options5"
        },
        ["森林石化"] = {
            en = "petrification",
            value = "default",
            type = "petrification"
        },
        ["流星频率"] = {
            en = "meteorshowers",
            value = "default",
            type = "options5"
        },
        ["追猎惊喜"] = {
            en = "alternatehunt",
            value = "default",
            type = "options5"
        }
    },
    ["资源再生"] = {
        array = {"重生速度", "花", "月树", "盐堆", "多枝树", "常青树", "桦栗树", "胡萝卜"},
        ["重生速度"] = {
            en = "regrowth",
            value = "default",
            type = "regrowthspeed"
        },
        ["花"] = {
            en = "flowers_regrowth",
            value = "default",
            type = "regrowthspeed"
        },
        ["月树"] = {
            en = "moon_tree_regrowth",
            value = "default",
            type = "regrowthspeed"
        },
        ["盐堆"] = {
            en = "saltstack_regrowth",
            value = "default",
            type = "regrowthspeed"
        },
        ["多枝树"] = {
            en = "twiggytrees_regrowth",
            value = "never",
            type = "regrowthspeed"
        },
        ["常青树"] = {
            en = "evergreen_regrowth",
            value = "default",
            type = "regrowthspeed"
        },
        ["桦栗树"] = {
            en = "deciduoustree_regrowth",
            value = "default",
            type = "regrowthspeed"
        },
        ["胡萝卜"] = {
            en = "carrots_regrowth",
            value = "default",
            type = "regrowthspeed"
        }
    },
    ["生物"] = {
        array = {"猪", "鸟", "企鹅", "兔人", "兔子", "浣猫", "火鸡", "蜜蜂", "蝴蝶", "鱼群", "鼹鼠", "龙虾", "一角鲸", "草壁虎转化"},
        ["猪"] = {
            en = "pigs_setting",
            value = "default",
            type = "options5"
        },
        ["鸟"] = {
            en = "birds",
            value = "default",
            type = "options5"
        },
        ["企鹅"] = {
            en = "penguins",
            value = "default",
            type = "options5"
        },
        ["兔人"] = {
            en = "bunnymen_setting",
            value = "default",
            type = "options5"
        },
        ["兔子"] = {
            en = "rabbits_setting",
            value = "default",
            type = "options5"
        },
        ["浣猫"] = {
            en = "catcoons",
            value = "default",
            type = "options5"
        },
        ["火鸡"] = {
            en = "perd",
            value = "default",
            type = "options5"
        },
        ["蜜蜂"] = {
            en = "bees_setting",
            value = "default",
            type = "options5"
        },
        ["蝴蝶"] = {
            en = "butterfly",
            value = "default",
            type = "options5"
        },
        ["鱼群"] = {
            en = "fishschools",
            value = "default",
            type = "options5"
        },
        ["鼹鼠"] = {
            en = "moles_setting",
            value = "default",
            type = "options5"
        },
        ["龙虾"] = {
            en = "wobsters",
            value = "default",
            type = "options5"
        },
        ["一角鲸"] = {
            en = "gnarwail",
            value = "default",
            type = "options5"
        },
        ["草壁虎转化"] = {
            en = "grassgekkos",
            value = "never",
            type = "options5"
        }
    },
    ["敌对生物"] = {
        array = {"海象", "猎犬", "蚊子", "蜘蛛", "蝙蝠", "青蛙", "鱼人", "鱿鱼", "鲨鱼", "杀人蜂", "食人花", "恐怖猎犬", "月石企鹅", "破碎蜘蛛", "蜘蛛战士", "饼干切割机"},
        ["海象"] = {
            en = "walrus_setting",
            value = "default",
            type = "options5"
        },
        ["猎犬"] = {
            en = "hound_mounds",
            value = "default",
            type = "options5"
        },
        ["蚊子"] = {
            en = "mosquitos",
            value = "default",
            type = "options5"
        },
        ["蜘蛛"] = {
            en = "spiders_setting",
            value = "default",
            type = "options5"
        },
        ["蝙蝠"] = {
            en = "bats_setting",
            value = "default",
            type = "options5"
        },
        ["青蛙"] = {
            en = "frogs",
            value = "default",
            type = "options5"
        },
        ["鱼人"] = {
            en = "merms",
            value = "default",
            type = "options5"
        },
        ["鱿鱼"] = {
            en = "squid",
            value = "default",
            type = "options5"
        },
        ["鲨鱼"] = {
            en = "sharks",
            value = "default",
            type = "options5"
        },
        ["杀人蜂"] = {
            en = "wasps",
            value = "default",
            type = "options5"
        },
        ["食人花"] = {
            en = "lureplants",
            value = "default",
            type = "options5"
        },
        ["恐怖猎犬"] = {
            en = "mutated_hounds",
            value = "default",
            type = "defaultnever"
        },
        ["月石企鹅"] = {
            en = "penguins_moon",
            value = "default",
            type = "defaultnever"
        },
        ["破碎蜘蛛"] = {
            en = "moon_spider",
            value = "default",
            type = "options5"
        },
        ["蜘蛛战士"] = {
            en = "spider_warriors",
            value = "default",
            type = "defaultnever"
        },
        ["饼干切割机"] = {
            en = "cookiecutters",
            value = "default",
            type = "options5"
        }
    },
    ["巨兽"] = {
        array = {"熊獾", "蜂后", "龙蝇", "克劳斯", "帝王蟹", "果蝇王", "邪天翁", "麋鹿鹅", "恐怖之眼", "树精守卫", "毒桦栗树", "独眼巨鹿", "蚁狮", "蜘蛛女王"},
        ["熊獾"] = {
            en = "bearger",
            value = "default",
            type = "options5"
        },
        ["蜂后"] = {
            en = "beequeen",
            value = "default",
            type = "options5"
        },
        ["龙蝇"] = {
            en = "dragonfly",
            value = "default",
            type = "options5"
        },
        ["克劳斯"] = {
            en = "klaus",
            value = "default",
            type = "options5"
        },
        ["帝王蟹"] = {
            en = "crabking",
            value = "default",
            type = "options5"
        },
        ["果蝇王"] = {
            en = "fruitfly",
            value = "default",
            type = "options5"
        },
        ["邪天翁"] = {
            en = "malbatross",
            value = "default",
            type = "options5"
        },
        ["麋鹿鹅"] = {
            en = "goosemoose",
            value = "default",
            type = "options5"
        },
        ["恐怖之眼"] = {
            en = "eyeofterror",
            value = "default",
            type = "options5"
        },
        ["树精守卫"] = {
            en = "liefs",
            value = "default",
            type = "options5"
        },
        ["毒桦栗树"] = {
            en = "deciduousmonster",
            value = "default",
            type = "options5"
        },
        ["独眼巨鹿"] = {
            en = "deerclops",
            value = "default",
            type = "options5"
        },
        ["蚁狮"] = {
            en = "antliontribute",
            value = "default",
            type = "options5"
        },
        ["蜘蛛女王"] = {
            en = "spiderqueen",
            value = "default",
            type = "options5"
        }
    }
}
