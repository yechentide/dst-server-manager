-- 注: lua里面要用中文当key的话, 得像这样 --> [[[中文]] ] 或者 ["中文"]
-- 由于dictionary的key是无序的, 所以这里用array来保存key的顺序

-- 以下table里面的type, 指定了world_value_types.lua里面的key

cave_generations_table = {
    array = {"世界", "资源", "生物以及刷新点", "敌对生物以及刷新点"},
    ["世界"] = {
        array = {"生物群落", "出生点", "世界大小", "分支", "环形", "试金石", "洞穴光照", "失败的冒险家", "开始资源多样化"},
        ["生物群落"] = {
            key = "task_set",
            value = "cave_default",
            type = "biomecave"
        },
        ["出生点"] = {
            key = "start_location",
            value = "caves",
            type = "startlocationcave"
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
        ["试金石"] = {
            key = "touchstone",
            value = "default",
            type = "options8"
        },
        ["洞穴光照"] = {
            key = "cavelight",
            value = "default",
            type = "regrowthspeed"
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
        }
    },
    ["资源"] = {
        array = {"草", "巨石", "树苗", "池塘", "燧石", "芦苇", "苔藓", "蘑菇", "尖灌木", "浆果丛", "荧光花", "蘑菇树", "发光浆果", "洞穴蕨类", "洞穴香蕉", "树(所有)"},
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
        ["树苗"] = {
            key = "sapling",
            value = "default",
            type = "options8"
        },
        ["池塘"] = {
            key = "cave_ponds",
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
        ["苔藓"] = {
            key = "lichen",
            value = "default",
            type = "options8"
        },
        ["蘑菇"] = {
            key = "mushroom",
            value = "default",
            type = "options8"
        },
        ["尖灌木"] = {
            key = "marshbush",
            value = "default",
            type = "options8"
        },
        ["浆果丛"] = {
            key = "berrybush",
            value = "default",
            type = "options8"
        },
        ["荧光花"] = {
            key = "flower_cave",
            value = "default",
            type = "options8"
        },
        ["蘑菇树"] = {
            key = "mushtree",
            value = "default",
            type = "options8"
        },
        ["发光浆果"] = {
            key = "wormlights",
            value = "default",
            type = "options8"
        },
        ["洞穴蕨类"] = {
            key = "fern",
            value = "default",
            type = "options8"
        },
        ["洞穴香蕉"] = {
            key = "banana",
            value = "default",
            type = "options8"
        },
        ["树(所有)"] = {
            key = "trees",
            value = "default",
            type = "options8"
        }
    },
    ["生物以及刷新点"] = {
        array = {"兔屋", "石虾", "缀食者", "穴居猴桶", "蛞蝓龟窝"},
        ["兔屋"] = {
            key = "bunnymen",
            value = "default",
            type = "options8"
        },
        ["石虾"] = {
            key = "rocky",
            value = "default",
            type = "options8"
        },
        ["缀食者"] = {
            key = "slurper",
            value = "default",
            type = "options8"
        },
        ["穴居猴桶"] = {
            key = "monkey",
            value = "default",
            type = "options8"
        },
        ["蛞蝓龟窝"] = {
            key = "slurtles",
            value = "default",
            type = "options8"
        }
    },
    ["敌对生物以及刷新点"] = {
        array = {"蝙蝠", "触手", "蛛网岩", "蜘蛛巢", "发条装置", "梦魇裂隙", "洞穴蠕虫"},
        ["蝙蝠"] = {
            key = "bats",
            value = "default",
            type = "options8"
        },
        ["触手"] = {
            key = "tentacles",
            value = "default",
            type = "options8"
        },
        ["蛛网岩"] = {
            key = "cave_spiders",
            value = "default",
            type = "options8"
        },
        ["蜘蛛巢"] = {
            key = "spiders",
            value = "default",
            type = "options8"
        },
        ["发条装置"] = {
            key = "chess",
            value = "default",
            type = "options8"
        },
        ["梦魇裂隙"] = {
            key = "fissure",
            value = "default",
            type = "options8"
        },
        ["洞穴蠕虫"] = {
            key = "worms",
            value = "default",
            type = "options8"
        }
    }
}

cave_settings_table = {
    array = {"世界", "资源再生", "生物", "敌对生物", "巨兽"};
    ["世界"] = {
        array = {"雨", "地震", "远古大门", "洞穴蠕虫攻击"},
        ["雨"] = {
            key = "weather",
            value = "default",
            type = "options5"
        },
        ["地震"] = {
            key = "earthquakes",
            value = "default",
            type = "options5"
        },
        ["远古大门"] = {
            key = "atriumgate",
            value = "default",
            type = "options5"
        },
        ["洞穴蠕虫攻击"] = {
            key = "wormattacks",
            value = "default",
            type = "options5"
        }
    },
    ["资源再生"] = {
        array = {"重生速度", "荧光花", "蘑菇树", "月亮蘑菇树", "球状光虫花"},
        ["重生速度"] = {
            key = "regrowth",
            value = "default",
            type = "regrowthspeed"
        },
        ["荧光花"] = {
            key = "flower_cave_regrowth",
            value = "default",
            type = "regrowthspeed"
        },
        ["蘑菇树"] = {
            key = "mushtree_regrowth",
            value = "default",
            type = "regrowthspeed"
        },
        ["月亮蘑菇树"] = {
            key = "mushtree_moon_regrowth",
            value = "default",
            type = "regrowthspeed"
        },
        ["球状光虫花"] = {
            key = "lightflier_flower_regrowth",
            value = "default",
            type = "regrowthspeed"
        }
    },
    ["生物"] = {
        array = {"猪", "兔人", "尘蛾", "石虾", "鼹鼠", "穴居猴", "蛞蝓龟", "蜗牛龟", "球状光虫", "蘑菇地精", "草壁虎转化"},
        ["猪"] = {
            key = "pigs_setting",
            value = "default",
            type = "options5"
        },
        ["兔人"] = {
            key = "bunnymen_setting",
            value = "default",
            type = "options5"
        },
        ["尘蛾"] = {
            key = "dustmoths",
            value = "default",
            type = "options5"
        },
        ["石虾"] = {
            key = "rocky_setting",
            value = "default",
            type = "options5"
        },
        ["鼹鼠"] = {
            key = "moles_setting",
            value = "default",
            type = "options5"
        },
        ["穴居猴"] = {
            key = "monkey_setting",
            value = "default",
            type = "options5"
        },
        ["蛞蝓龟"] = {
            key = "slurtles_setting",
            value = "default",
            type = "options5"
        },
        ["蜗牛龟"] = {
            key = "snurtles",
            value = "default",
            type = "options5"
        },
        ["球状光虫"] = {
            key = "lightfliers",
            value = "default",
            type = "options5"
        },
        ["蘑菇地精"] = {
            key = "mushgnome",
            value = "default",
            type = "options5"
        },
        ["草壁虎转化"] = {
            key = "grassgekkos",
            value = "never",
            type = "options5"
        }
    },
    ["敌对生物"] = {
        array = {"蜘蛛", "蝙蝠", "鱼人", "喷射蜘蛛", "洞穴蜘蛛", "穴居悬蛛", "蜘蛛战士", "遗迹梦魇", "裸鼹鼠蝙蝠"},
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
        ["鱼人"] = {
            key = "merms",
            value = "default",
            type = "options5"
        },
        ["喷射蜘蛛"] = {
            key = "spider_spitter",
            value = "default",
            type = "options5"
        },
        ["洞穴蜘蛛"] = {
            key = "spider_hider",
            value = "default",
            type = "options5"
        },
        ["穴居悬蛛"] = {
            key = "spider_dropper",
            value = "default",
            type = "options5"
        },
        ["蜘蛛战士"] = {
            key = "spider_warriors",
            value = "default",
            type = "defaultnever"
        },
        ["遗迹梦魇"] = {
            key = "nightmarecreatures",
            value = "default",
            type = "options5"
        },
        ["裸鼹鼠蝙蝠"] = {
            key = "molebats",
            value = "default",
            type = "options5"
        }
    },
    ["巨兽"] = {
        array = {"果蝇王", "树精守卫", "毒菌蟾蜍", "蜘蛛女王"},
        ["果蝇王"] = {
            key = "fruitfly",
            value = "default",
            type = "options5"
        },
        ["树精守卫"] = {
            key = "liefs",
            value = "default",
            type = "options5"
        },
        ["毒菌蟾蜍"] = {
            key = "toadstool",
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
