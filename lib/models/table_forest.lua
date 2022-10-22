-- 注: lua里面要用中文当key的话, 得像这样 --> [[[中文]] ] 或者 ["中文"]
-- 由于dictionary的key是无序的, 所以这里用array来保存key的顺序

-- 以下table里面的type, 指定了world_value_types.lua里面的key

-- WORLDGEN
forest_generations_table = {
    array = {"全局", "世界", "资源", "生物以及刷新点", "敌对生物以及刷新点"},
    ["全局"] = {
        array = {"起始季节"},
        ["起始季节"] = {
            key = "season_start",
            value = "default",
            type = "startseason"
        }
    },
    -- MISC
    ["世界"] = {
        array = {"生物群落", "出生点", "世界大小", "分支", "环形", "道路", "试金石", "失败的冒险家", "开始资源多样化", "天体裂隙", "盒中泰拉", "舞台剧"},
        ["生物群落"] = {
            key = "task_set",
            value = "default",
            type = "biomeforest"
        },
        ["出生点"] = {
            key = "start_location",
            value = "default",
            type = "startlocationforest"
        },
        ["世界大小"] = {
            key = "world_size",
            value = "default",
            type = "worldsize"
        },
        ["分支"] = {
            key = "branching",
            value = "default",
            type = "branch"
        },
        ["环形"] = {
            key = "loop",
            value = "default",
            type = "loop"
        },
        ["道路"] = {
            key = "roads",
            value = "default",
            type = "defaultnever"
        },
        ["试金石"] = {
            key = "touchstone",
            value = "default",
            type = "options8"
        },
        ["失败的冒险家"] = {
            key = "boons",
            value = "default",
            type = "options8"
        },
        ["开始资源多样化"] = {
            key = "prefabswaps_start",
            value = "default",
            type = "prefabswapsstart"
        },
        ["天体裂隙"] = {
            key = "moon_fissure",
            value = "default",
            type = "options8"
        },
        ["盒中泰拉"] = {
            key = "terrariumchest",
            value = "default",
            type = "defaultnever"
        },
        ["舞台剧"] = {
            key = "stageplays",
            value = "default",
            type = "defaultnever"
        }
    },
    -- RESOURCES
    ["资源"] = {
        array = {"草", "巨石", "月树", "树苗", "池塘", "浮堆", "海星", "温泉", "燧石", "芦苇", "蘑菇", "仙人掌", "尖灌木", "月亮石", "浆果丛", "胡萝卜", "风滚草", "公牛海带", "月亮树苗", "流星区域", "迷你冰川", "树(所有)", "石果灌木丛", "花，邪恶花", "海岸公牛海带", "棕榈松果树"},
        ["草"] = {
            key = "grass",
            value = "default",
            type = "options8"
        },
        ["巨石"] = {
            key = "rock",
            value = "default",
            type = "options8"
        },
        ["月树"] = {
            key = "moon_tree",
            value = "default",
            type = "options8"
        },
        ["树苗"] = {
            key = "sapling",
            value = "default",
            type = "options8"
        },
        ["池塘"] = {
            key = "ponds",
            value = "default",
            type = "options8"
        },
        ["浮堆"] = {
            key = "ocean_seastack",
            value = "ocean_default",
            type = "oceanoptions"
        },
        ["海星"] = {
            key = "moon_starfish",
            value = "default",
            type = "options8"
        },
        ["温泉"] = {
            key = "moon_hotspring",
            value = "default",
            type = "options8"
        },
        ["燧石"] = {
            key = "flint",
            value = "default",
            type = "options8"
        },
        ["芦苇"] = {
            key = "reeds",
            value = "default",
            type = "options8"
        },
        ["蘑菇"] = {
            key = "mushroom",
            value = "default",
            type = "options8"
        },
        ["仙人掌"] = {
            key = "cactus",
            value = "default",
            type = "options8"
        },
        ["尖灌木"] = {
            key = "marshbush",
            value = "default",
            type = "options8"
        },
        ["月亮石"] = {
            key = "moon_rock",
            value = "default",
            type = "options8"
        },
        ["浆果丛"] = {
            key = "berrybush",
            value = "default",
            type = "options8"
        },
        ["胡萝卜"] = {
            key = "carrot",
            value = "default",
            type = "options8"
        },
        ["风滚草"] = {
            key = "tumbleweed",
            value = "default",
            type = "options8"
        },
        ["公牛海带"] = {
            key = "ocean_bullkelp",
            value = "default",
            type = "options8"
        },
        ["月亮树苗"] = {
            key = "moon_sapling",
            value = "default",
            type = "options8"
        },
        ["流星区域"] = {
            key = "meteorspawner",
            value = "default",
            type = "options8"
        },
        ["迷你冰川"] = {
            key = "rock_ice",
            value = "default",
            type = "options8"
        },
        ["树(所有)"] = {
            key = "trees",
            value = "default",
            type = "options8"
        },
        ["石果灌木丛"] = {
            key = "moon_berrybush",
            value = "default",
            type = "options8"
        },
        ["花，邪恶花"] = {
            key = "flowers",
            value = "default",
            type = "options8"
        },
        ["海岸公牛海带"] = {
            key = "moon_bullkelp",
            value = "default",
            type = "options8"
        },
        ["棕榈松果树"] = {
            key = "palmconetree",
            value = "default",
            type = "options8"
        }
    },
    ["生物以及刷新点"] = {
        array = {"兔洞", "猪屋", "秃鹫", "鱼群", "伏特羊", "鼹鼠洞", "龙虾窝", "沙拉蝾螈", "皮费娄牛", "空心树桩", "胡萝卜鼠", "蜜蜂蜂窝"},
        ["兔洞"] = {
            key = "rabbits",
            value = "default",
            type = "options8"
        },
        ["猪屋"] = {
            key = "pigs",
            value = "default",
            type = "options8"
        },
        ["秃鹫"] = {
            key = "buzzard",
            value = "default",
            type = "options8"
        },
        ["鱼群"] = {
            key = "ocean_shoal",
            value = "default",
            type = "options8"
        },
        ["伏特羊"] = {
            key = "lightninggoat",
            value = "default",
            type = "options8"
        },
        ["鼹鼠洞"] = {
            key = "moles",
            value = "default",
            type = "options8"
        },
        ["龙虾窝"] = {
            key = "ocean_wobsterden",
            value = "default",
            type = "options8"
        },
        ["沙拉蝾螈"] = {
            key = "moon_fruitdragon",
            value = "default",
            type = "options8"
        },
        ["皮费娄牛"] = {
            key = "beefalo",
            value = "default",
            type = "options8"
        },
        ["空心树桩"] = {
            key = "catcoon",
            value = "default",
            type = "options8"
        },
        ["胡萝卜鼠"] = {
            key = "moon_carrot",
            value = "default",
            type = "options8"
        },
        ["蜜蜂蜂窝"] = {
            key = "bees",
            value = "default",
            type = "options8"
        }
    },
    ["敌对生物以及刷新点"] = {
        array = {"海草", "触手", "猎犬丘", "蜘蛛巢", "高脚鸟", "发条装置", "海象营地", "杀人蜂蜂窝", "漏雨的小屋", "破碎蜘蛛洞"},
        ["海草"] = {
            key = "ocean_waterplant",
            value = "ocean_default",
            type = "oceanoptions"
        },
        ["触手"] = {
            key = "tentacles",
            value = "default",
            type = "options8"
        },
        ["猎犬丘"] = {
            key = "houndmound",
            value = "default",
            type = "options8"
        },
        ["蜘蛛巢"] = {
            key = "spiders",
            value = "default",
            type = "options8"
        },
        ["高脚鸟"] = {
            key = "tallbirds",
            value = "default",
            type = "options8"
        },
        ["发条装置"] = {
            key = "chess",
            value = "default",
            type = "options8"
        },
        ["海象营地"] = {
            key = "walrus",
            value = "default",
            type = "options8"
        },
        ["杀人蜂蜂窝"] = {
            key = "angrybees",
            value = "default",
            type = "options8"
        },
        ["漏雨的小屋"] = {
            key = "merm",
            value = "default",
            type = "options8"
        },
        ["破碎蜘蛛洞"] = {
            key = "moon_spiders",
            value = "default",
            type = "options8"
        }
    }
}

-- WORLDSETTINGS
forest_settings_table = {
    array = {"全局", "活动", "冒险家", "世界", "资源再生", "生物", "敌对生物", "巨兽"},
    -- GLOBAL
    ["全局"] = {
        array = {"活动", "春", "夏", "秋", "冬", "昼夜选项", "皮费娄牛交配频率", "坎普斯", "出生模式", "冒险家死亡", "在绚丽之门复活", "鬼魂精神值惩罚", "死亡重置倒计时"},
        ["活动"] = {
            key = "specialevent",
            value = "default",
            type = "event"
        },
        ["春"] = {
            key = "spring",
            value = "default",
            type = "seasonlength"
        },
        ["夏"] = {
            key = "summer",
            value = "default",
            type = "seasonlength"
        },
        ["秋"] = {
            key = "autumn",
            value = "default",
            type = "seasonlength"
        },
        ["冬"] = {
            key = "winter",
            value = "default",
            type = "seasonlength"
        },
        ["昼夜选项"] = {
            key = "day",
            value = "default",
            type = "daytype"
        },
        ["皮费娄牛交配频率"] = {
            key = "beefaloheat",
            value = "default",
            type = "options5"
        },
        ["坎普斯"] = {
            key = "krampus",
            value = "default",
            type = "options5"
        },
        ["出生模式"] = {
            key = "spawnmode",
            value = "fixed",
            type = "mode01"
        },
        ["冒险家死亡"] = {
            key = "ghostenabled",
            value = "always",
            type = "nonealways4ghost"
        },
        ["在绚丽之门复活"] = {
            key = "portalresurection",
            value = "none",
            type = "nonealways"
        },
        ["鬼魂精神值惩罚"] = {
            key = "ghostsanitydrain",
            value = "always",
            type = "nonealways"
        },
        ["死亡重置倒计时"] = {
            key = "resettime",
            value = "default",
            type = "resettime"
        }
    },
    ["活动"] = {
        array = {"盛夏鸭年华", "万圣夜", "冬季盛宴", "火鸡之年", "座狼之年", "猪王之年", "胡萝卜鼠之年", "皮弗娄牛之年", "浣猫之年"},
        ["盛夏鸭年华"] = {
            key = "crow_carnival",
            value = "default",
            type = "specificevent"
        },
        ["万圣夜"] = {
            key = "hallowed_nights",
            value = "default",
            type = "specificevent"
        },
        ["冬季盛宴"] = {
            key = "winters_feast",
            value = "default",
            type = "specificevent"
        },
        ["火鸡之年"] = {
            key = "year_of_the_gobbler",
            value = "default",
            type = "specificevent"
        },
        ["座狼之年"] = {
            key = "year_of_the_varg",
            value = "default",
            type = "specificevent"
        },
        ["猪王之年"] = {
            key = "year_of_the_pig",
            value = "default",
            type = "specificevent"
        },
        ["胡萝卜鼠之年"] = {
            key = "year_of_the_carrat",
            value = "default",
            type = "specificevent"
        },
        ["皮弗娄牛之年"] = {
            key = "year_of_the_beefalo",
            value = "default",
            type = "specificevent"
        },
        ["浣猫之年"] = {
            key = "year_of_the_catcoon",
            value = "default",
            type = "specificevent"
        },
    },
    --SURVIVORS
    ["冒险家"] = {
        array = {"额外起始资源", "季节起始物品", "防骚扰出生保护", "离开游戏后物品掉落", "启蒙怪兽", "理智怪兽", "血量上限惩罚", "受到的破坏", "温度伤害", "饥饿伤害", "黑暗伤害"},
        ["额外起始资源"] = {
            key = "extrastartingitems",
            value = "default",
            type = "extrastartingitems"
        },
        ["季节起始物品"] = {
            key = "seasonalstartingitems",
            value = "default",
            type = "defaultnever"
        },
        ["防骚扰出生保护"] = {
            key = "spawnprotection",
            value = "default",
            type = "loop"
        },
        ["离开游戏后物品掉落"] = {
            key = "dropeverythingondespawn",
            value = "default",
            type = "defaultalways"
        },
        ["启蒙怪兽"] = {
            key = "brightmarecreatures",
            value = "default",
            type = "options5"
        },
        ["理智怪兽"] = {
            key = "shadowcreatures",
            value = "default",
            type = "options5"
        },
        ["血量上限惩罚"] = {
            key = "healthpenalty",
            value = "always",
            type = "nonealways"
        },
        ["受到的破坏"] = {
            key = "lessdamagetaken",
            value = "none",
            type = "damage01"
        },
        ["温度伤害"] = {
            key = "temperaturedamage",
            value = "default",
            type = "damage02"
        },
        ["饥饿伤害"] = {
            key = "hunger",
            value = "default",
            type = "damage02"
        },
        ["黑暗伤害"] = {
            key = "darkness",
            value = "default",
            type = "damage02"
        }
    },
    ["世界"] = {
        array = {"猎犬袭击", "冰猎犬群", "火猎犬群", "雨", "狩猎", "野火", "闪电", "青蛙雨", "森林石化", "流星频率", "追猎惊喜"},
        ["猎犬袭击"] = {
            key = "hounds",
            value = "default",
            type = "options5"
        },
        ["冰猎犬群"] = {
            key = "winterhounds",
            value = "default",
            type = "defaultnever"
        },
        ["火猎犬群"] = {
            key = "summerhounds",
            value = "default",
            type = "defaultnever"
        },
        ["雨"] = {
            key = "weather",
            value = "default",
            type = "options5"
        },
        ["狩猎"] = {
            key = "hunt",
            value = "default",
            type = "options5"
        },
        ["野火"] = {
            key = "wildfires",
            value = "default",
            type = "options5"
        },
        ["闪电"] = {
            key = "lightning",
            value = "default",
            type = "options5"
        },
        ["青蛙雨"] = {
            key = "frograin",
            value = "default",
            type = "options5"
        },
        ["森林石化"] = {
            key = "petrification",
            value = "default",
            type = "petrification"
        },
        ["流星频率"] = {
            key = "meteorshowers",
            value = "default",
            type = "options5"
        },
        ["追猎惊喜"] = {
            key = "alternatehunt",
            value = "default",
            type = "options5"
        }
    },
    -- RESOURCES
    ["资源再生"] = {
        array = {"重生速度", "花", "月树", "盐堆", "多枝树", "常青树", "桦栗树", "胡萝卜", "仙人掌", "基础资源", "棕榈松果树", "芦苇"},
        ["重生速度"] = {
            key = "regrowth",
            value = "default",
            type = "regrowthspeed"
        },
        ["花"] = {
            key = "flowers_regrowth",
            value = "default",
            type = "regrowthspeed"
        },
        ["月树"] = {
            key = "moon_tree_regrowth",
            value = "default",
            type = "regrowthspeed"
        },
        ["盐堆"] = {
            key = "saltstack_regrowth",
            value = "default",
            type = "regrowthspeed"
        },
        ["多枝树"] = {
            key = "twiggytrees_regrowth",
            value = "never",
            type = "regrowthspeed"
        },
        ["常青树"] = {
            key = "evergreen_regrowth",
            value = "default",
            type = "regrowthspeed"
        },
        ["桦栗树"] = {
            key = "deciduoustree_regrowth",
            value = "default",
            type = "regrowthspeed"
        },
        ["胡萝卜"] = {
            key = "carrots_regrowth",
            value = "default",
            type = "regrowthspeed"
        },
        ["仙人掌"] = {
            key = "cactus_regrowth",
            value = "default",
            type = "regrowthspeed"
        },
        ["基础资源"] = {
            key = "basicresource_regrowth",
            value = "none",
            type = "nonealways"
        },
        ["棕榈松果树"] = {
            key = "palmconetree_regrowth",
            value = "default",
            type = "regrowthspeed"
        },
        ["芦苇"] = {
            key = "reeds_regrowth",
            value = "default",
            type = "regrowthspeed"
        }
    },
    -- UNNATURAL PORTAL
    ["非自然传送门资源"] = {
        array = {"传送率", "发光蟹", "棕榈松果树芽", "火药猴", "猴尾草", "香蕉丛"},
        ["传送率"] = {
            key = "portal_spawnrate",
            value = "default",
            type = "options5"
        },
        ["发光蟹"] = {
            key = "lightcrab_portalrate",
            value = "default",
            type = "options5"
        },
        ["棕榈松果树芽"] = {
            key = "palmcone_seed_portalrate",
            value = "default",
            type = "options5"
        },
        ["火药猴"] = {
            key = "powder_monkey_portalrate",
            value = "default",
            type = "options5"
        },
        ["猴尾草"] = {
            key = "monkeytail_portalrate",
            value = "default",
            type = "options5"
        },
        ["香蕉丛"] = {
            key = "bananabush_portalrate",
            value = "default",
            type = "options5"
        }
    },
    ["生物"] = {
        array = {"猪", "鸟", "企鹅", "兔人", "兔子", "浣猫", "火鸡", "蜜蜂", "蝴蝶", "鱼群", "鼹鼠", "龙虾", "一角鲸", "草壁虎转化"},
        ["猪"] = {
            key = "pigs_setting",
            value = "default",
            type = "options5"
        },
        ["鸟"] = {
            key = "birds",
            value = "default",
            type = "options5"
        },
        ["企鹅"] = {
            key = "penguins",
            value = "default",
            type = "options5"
        },
        ["兔人"] = {
            key = "bunnymen_setting",
            value = "default",
            type = "options5"
        },
        ["兔子"] = {
            key = "rabbits_setting",
            value = "default",
            type = "options5"
        },
        ["浣猫"] = {
            key = "catcoons",
            value = "default",
            type = "options5"
        },
        ["火鸡"] = {
            key = "perd",
            value = "default",
            type = "options5"
        },
        ["蜜蜂"] = {
            key = "bees_setting",
            value = "default",
            type = "options5"
        },
        ["蝴蝶"] = {
            key = "butterfly",
            value = "default",
            type = "options5"
        },
        ["鱼群"] = {
            key = "fishschools",
            value = "default",
            type = "options5"
        },
        ["鼹鼠"] = {
            key = "moles_setting",
            value = "default",
            type = "options5"
        },
        ["龙虾"] = {
            key = "wobsters",
            value = "default",
            type = "options5"
        },
        ["一角鲸"] = {
            key = "gnarwail",
            value = "default",
            type = "options5"
        },
        ["草壁虎转化"] = {
            key = "grassgekkos",
            value = "never",
            type = "options5"
        }
    },
    -- MONSTERS
    ["敌对生物"] = {
        array = {"海象", "猎犬", "蚊子", "蜘蛛", "蝙蝠", "青蛙", "鱼人", "鱿鱼", "鲨鱼", "杀人蜂", "食人花", "恐怖猎犬", "月石企鹅", "破碎蜘蛛", "蜘蛛战士", "饼干切割机", "月亮码头海盗"},
        ["海象"] = {
            key = "walrus_setting",
            value = "default",
            type = "options5"
        },
        ["猎犬"] = {
            key = "hound_mounds",
            value = "default",
            type = "options5"
        },
        ["蚊子"] = {
            key = "mosquitos",
            value = "default",
            type = "options5"
        },
        ["蜘蛛"] = {
            key = "spiders_setting",
            value = "default",
            type = "options5"
        },
        ["蝙蝠"] = {
            key = "bats_setting",
            value = "default",
            type = "options5"
        },
        ["青蛙"] = {
            key = "frogs",
            value = "default",
            type = "options5"
        },
        ["鱼人"] = {
            key = "merms",
            value = "default",
            type = "options5"
        },
        ["鱿鱼"] = {
            key = "squid",
            value = "default",
            type = "options5"
        },
        ["鲨鱼"] = {
            key = "sharks",
            value = "default",
            type = "options5"
        },
        ["杀人蜂"] = {
            key = "wasps",
            value = "default",
            type = "options5"
        },
        ["食人花"] = {
            key = "lureplants",
            value = "default",
            type = "options5"
        },
        ["恐怖猎犬"] = {
            key = "mutated_hounds",
            value = "default",
            type = "defaultnever"
        },
        ["月石企鹅"] = {
            key = "penguins_moon",
            value = "default",
            type = "defaultnever"
        },
        ["破碎蜘蛛"] = {
            key = "moon_spider",
            value = "default",
            type = "options5"
        },
        ["蜘蛛战士"] = {
            key = "spider_warriors",
            value = "default",
            type = "defaultnever"
        },
        ["饼干切割机"] = {
            key = "cookiecutters",
            value = "default",
            type = "options5"
        },
        ["月亮码头海盗"] = {
            key = "pirateraids",
            value = "default",
            type = "options5"
        }
    },
    ["巨兽"] = {
        array = {"熊獾", "蜂后", "龙蝇", "克劳斯", "帝王蟹", "果蝇王", "邪天翁", "麋鹿鹅", "恐怖之眼", "树精守卫", "毒桦栗树", "独眼巨鹿", "蚁狮", "蜘蛛女王"},
        ["熊獾"] = {
            key = "bearger",
            value = "default",
            type = "options5"
        },
        ["蜂后"] = {
            key = "beequeen",
            value = "default",
            type = "options5"
        },
        ["龙蝇"] = {
            key = "dragonfly",
            value = "default",
            type = "options5"
        },
        ["克劳斯"] = {
            key = "klaus",
            value = "default",
            type = "options5"
        },
        ["帝王蟹"] = {
            key = "crabking",
            value = "default",
            type = "options5"
        },
        ["果蝇王"] = {
            key = "fruitfly",
            value = "default",
            type = "options5"
        },
        ["邪天翁"] = {
            key = "malbatross",
            value = "default",
            type = "options5"
        },
        ["麋鹿鹅"] = {
            key = "goosemoose",
            value = "default",
            type = "options5"
        },
        ["恐怖之眼"] = {
            key = "eyeofterror",
            value = "default",
            type = "options5"
        },
        ["树精守卫"] = {
            key = "liefs",
            value = "default",
            type = "options5"
        },
        ["毒桦栗树"] = {
            key = "deciduousmonster",
            value = "default",
            type = "options5"
        },
        ["独眼巨鹿"] = {
            key = "deerclops",
            value = "default",
            type = "options5"
        },
        ["蚁狮"] = {
            key = "antliontribute",
            value = "default",
            type = "options5"
        },
        ["蜘蛛女王"] = {
            key = "spiderqueen",
            value = "default",
            type = "options5"
        }
    }
}

if shipwrecked == true then
    table.insert(forest_generations_table["array"], "Island世界")
    table.insert(forest_generations_table["array"], "Island食物")
    forest_generations_table["Island世界"] = {
        -- array = {"world type", "Island Quantity", "Volcano", "Drangon Eggs", "Tides", "Floods", "Waves", "Poison", "Electric Isosceles"},
        array = {"世界类型", "岛屿数量", "火山", "龙蛋", "潮汐", "洪水", "海浪", "毒气", "三角虫洞"},
        ["世界类型"] = {
            key = "primaryworldtype",
            value = "islandsonly",
            type = "shipwreckedworldtype"
        },
        ["岛屿数量"] = {
            key = "islandquantity",
            value = "small",
            type = "worldsize"
        },
        ["火山"] = {
            key = "volcano",
            value = "default",
            type = "defaultnever"
        },
        ["龙蛋"] = {
            key = "dragoonegg",
            value = "default",
            type = "options5"
        },
        ["潮汐"] = {
            key = "tides",
            value = "default",
            type = "defaultnever"
        },
        ["洪水"] = {
            key = "floods",
            value = "default",
            type = "options5"
        },
        ["海浪"] = {
            key = "oceanwaves",
            value = "default",
            type = "oceanwaves"
        },
        ["毒气"] = {
            key = "poison",
            value = "default",
            type = "defaultnever"
        },
        ["三角虫洞"] = {
            key = "bermudatriangle",
            value = "default",
            type = "options5"
        }
    }
    forest_generations_table["Island食物"] = {
        -- array = {"Sweet Potatoes", "Limpets", "Mussels"},
        array = {"红薯", "帽贝", "蚌"},
        ["红薯"] = {
            key = "sweet_potato",
            value = "default",
            type = "options5"
        },
        ["帽贝"] = {
            key = "limpets",
            value = "default",
            type = "options5"
        },
        ["蚌"] = {
            key = "mussel_farm",
            value = "default",
            type = "options5"
        }
        
    }

    table.insert(forest_settings_table["array"], "Island怪物")
    table.insert(forest_settings_table["array"], "Island动物")
    forest_settings_table["Island怪物"] = {
        -- array = {"Sealnoda", "Tiger Sharks", "Quacken", "Flup", "Poison Mosquitos", "Swordfish", "Stink Rays"},
        array = {"旋风海豹", "虎鲨", "海怪", "沼泽鱼", "毒蚊子", "剑鱼", "松鼠鱼"},
        ["旋风海豹"] = {
            key = "twister",
            value = "default",
            type = "options5"
        },
        ["虎鲨"] = {
            key = "tigershark",
            value = "default",
            type = "options5"
        },
        ["海怪"] = {
            key = "kraken",
            value = "default",
            type = "options5"
        },
        ["沼泽鱼"] = {
            key = "flup",
            value = "default",
            type = "options5"
        },
        ["毒蚊子"] = {
            key = "mosquito",
            value = "default",
            type = "options5"
        },
        ["剑鱼"] = {
            key = "swordfish",
            value = "default",
            type = "options5"
        },
        ["松鼠鱼"] = {
            key = "stungray",
            value = "default",
            type = "options5"
        }
    }
    forest_settings_table["Island动物"] = {
        -- array = {"Wildbores", "Whaling", "Crabbits", "Water Beefalos", "Dogfish", "Doydoys", "Jellyfish", "Wobsters", "Seagulls", "Ballphins", "Prime Apes"},
        array = {"野猪", "鲸鱼", "螃蟹", "水牛", "狗鱼", "渡渡鸟", "水母", "龙虾", "海鸥", "海豚", "猿猴"},
        ["野猪"] = {
            key = "wildbores",
            value = "default",
            type = "options5"
        },
        ["鲸鱼"] = {
            key = "whalehunt",
            value = "default",
            type = "options5"
        },
        ["螃蟹"] = {
            key = "crabhole",
            value = "default",
            type = "options5"
        },
        ["水牛"] = {
            key = "ox",
            value = "default",
            type = "options5"
        },
        ["狗鱼"] = {
            key = "solofish",
            value = "default",
            type = "options5"
        },
        ["渡渡鸟"] = {
            key = "doydoy",
            value = "default",
            type = "defaultnever"
        },
        ["水母"] = {
            key = "jellyfish",
            value = "default",
            type = "options5"
        },
        ["龙虾"] = {
            key = "lobster",
            value = "default",
            type = "options5"
        },
        ["海鸥"] = {
            key = "seagull",
            value = "default",
            type = "options5"
        },
        ["海豚"] = {
            key = "ballphin",
            value = "default",
            type = "options5"
        },
        ["猿猴"] = {
            key = "primeape",
            value = "default",
            type = "options5"
        }
    }
end
