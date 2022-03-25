-- 注: lua里面要用中文当key的话, 得像这样 --> [[[中文]] ] 或者 ["中文"]
-- 由于dictionary的key是无序的, 所以这里用array来保存key的顺序

-- 以下table里面的type, 指定了world_value_types.lua里面的key

cave_generations_table = {
    array = {"世界", "资源", "生物以及刷新点", "敌对生物以及刷新点"},
    ["世界"] = {
        array = {"生物群落", "出生点", "世界大小", "分支", "环形", "试金石", "洞穴光照", "失败的冒险家", "开始资源多样化"},
        ["生物群落"] = {
            en = "task_set",
            value = "cave_default",
            type = "biomecave"
        },
        ["出生点"] = {
            en = "start_location",
            value = "caves",
            type = "startlocationcave"
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
        ["试金石"] = {
            en = "touchstone",
            value = "default",
            type = "options8"
        },
        ["洞穴光照"] = {
            en = "cavelight",
            value = "default",
            type = "regrowthspeed"
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
        }
    },
    ["资源"] = {
        array = {"草", "巨石", "树苗", "池塘", "燧石", "芦苇", "苔藓", "蘑菇", "尖灌木", "浆果丛", "荧光花", "蘑菇树", "发光浆果", "洞穴蕨类", "洞穴香蕉", "树(所有)"},
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
        ["树苗"] = {
            en = "sapling",
            value = "default",
            type = "options8"
        },
        ["池塘"] = {
            en = "cave_ponds",
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
        ["苔藓"] = {
            en = "lichen",
            value = "default",
            type = "options8"
        },
        ["蘑菇"] = {
            en = "mushroom",
            value = "default",
            type = "options8"
        },
        ["尖灌木"] = {
            en = "marshbush",
            value = "default",
            type = "options8"
        },
        ["浆果丛"] = {
            en = "berrybush",
            value = "default",
            type = "options8"
        },
        ["荧光花"] = {
            en = "flower_cave",
            value = "default",
            type = "options8"
        },
        ["蘑菇树"] = {
            en = "mushtree",
            value = "default",
            type = "options8"
        },
        ["发光浆果"] = {
            en = "wormlights",
            value = "default",
            type = "options8"
        },
        ["洞穴蕨类"] = {
            en = "fern",
            value = "default",
            type = "options8"
        },
        ["洞穴香蕉"] = {
            en = "banana",
            value = "default",
            type = "options8"
        },
        ["树(所有)"] = {
            en = "trees",
            value = "default",
            type = "options8"
        }
    },
    ["生物以及刷新点"] = {
        array = {"兔屋", "石虾", "缀食者", "穴居猴桶", "蛞蝓龟窝"},
        ["兔屋"] = {
            en = "bunnymen",
            value = "default",
            type = "options8"
        },
        ["石虾"] = {
            en = "rocky",
            value = "default",
            type = "options8"
        },
        ["缀食者"] = {
            en = "slurper",
            value = "default",
            type = "options8"
        },
        ["穴居猴桶"] = {
            en = "monkey",
            value = "default",
            type = "options8"
        },
        ["蛞蝓龟窝"] = {
            en = "slurtles",
            value = "default",
            type = "options8"
        }
    },
    ["敌对生物以及刷新点"] = {
        array = {"蝙蝠", "触手", "蛛网岩", "蜘蛛巢", "发条装置", "梦魇裂隙", "洞穴蠕虫"},
        ["蝙蝠"] = {
            en = "bats",
            value = "default",
            type = "options8"
        },
        ["触手"] = {
            en = "tentacles",
            value = "default",
            type = "options8"
        },
        ["蛛网岩"] = {
            en = "cave_spiders",
            value = "default",
            type = "options8"
        },
        ["蜘蛛巢"] = {
            en = "spiders",
            value = "default",
            type = "options8"
        },
        ["发条装置"] = {
            en = "chess",
            value = "default",
            type = "options8"
        },
        ["梦魇裂隙"] = {
            en = "fissure",
            value = "default",
            type = "options8"
        },
        ["洞穴蠕虫"] = {
            en = "worms",
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
            en = "weather",
            value = "default",
            type = "options5"
        },
        ["地震"] = {
            en = "earthquakes",
            value = "default",
            type = "options5"
        },
        ["远古大门"] = {
            en = "atriumgate",
            value = "default",
            type = "options5"
        },
        ["洞穴蠕虫攻击"] = {
            en = "wormattacks",
            value = "default",
            type = "options5"
        }
    },
    ["资源再生"] = {
        array = {"重生速度", "荧光花", "蘑菇树", "月亮蘑菇树", "球状光虫花"},
        ["重生速度"] = {
            en = "regrowth",
            value = "default",
            type = "regrowthspeed"
        },
        ["荧光花"] = {
            en = "flower_cave_regrowth",
            value = "default",
            type = "regrowthspeed"
        },
        ["蘑菇树"] = {
            en = "mushtree_regrowth",
            value = "default",
            type = "regrowthspeed"
        },
        ["月亮蘑菇树"] = {
            en = "mushtree_moon_regrowth",
            value = "default",
            type = "regrowthspeed"
        },
        ["球状光虫花"] = {
            en = "lightflier_flower_regrowth",
            value = "default",
            type = "regrowthspeed"
        }
    },
    ["生物"] = {
        array = {"猪", "兔人", "尘蛾", "石虾", "鼹鼠", "穴居猴", "蛞蝓龟", "蜗牛龟", "球状光虫", "蘑菇地精", "草壁虎转化"},
        ["猪"] = {
            en = "pigs_setting",
            value = "default",
            type = "options5"
        },
        ["兔人"] = {
            en = "bunnymen_setting",
            value = "default",
            type = "options5"
        },
        ["尘蛾"] = {
            en = "dustmoths",
            value = "default",
            type = "options5"
        },
        ["石虾"] = {
            en = "rocky_setting",
            value = "default",
            type = "options5"
        },
        ["鼹鼠"] = {
            en = "moles_setting",
            value = "default",
            type = "options5"
        },
        ["穴居猴"] = {
            en = "monkey_setting",
            value = "default",
            type = "options5"
        },
        ["蛞蝓龟"] = {
            en = "slurtles_setting",
            value = "default",
            type = "options5"
        },
        ["蜗牛龟"] = {
            en = "snurtles",
            value = "default",
            type = "options5"
        },
        ["球状光虫"] = {
            en = "lightfliers",
            value = "default",
            type = "options5"
        },
        ["蘑菇地精"] = {
            en = "mushgnome",
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
        array = {"蜘蛛", "蝙蝠", "鱼人", "喷射蜘蛛", "洞穴蜘蛛", "穴居悬蛛", "蜘蛛战士", "遗迹梦魇", "裸鼹鼠蝙蝠"},
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
        ["鱼人"] = {
            en = "merms",
            value = "default",
            type = "options5"
        },
        ["喷射蜘蛛"] = {
            en = "spider_spitter",
            value = "default",
            type = "options5"
        },
        ["洞穴蜘蛛"] = {
            en = "spider_hider",
            value = "default",
            type = "options5"
        },
        ["穴居悬蛛"] = {
            en = "spider_dropper",
            value = "default",
            type = "options5"
        },
        ["蜘蛛战士"] = {
            en = "spider_warriors",
            value = "default",
            type = "defaultnever"
        },
        ["遗迹梦魇"] = {
            en = "nightmarecreatures",
            value = "default",
            type = "options5"
        },
        ["裸鼹鼠蝙蝠"] = {
            en = "molebats",
            value = "default",
            type = "options5"
        }
    },
    ["巨兽"] = {
        array = {"果蝇王", "树精守卫", "毒菌蟾蜍", "蜘蛛女王"},
        ["果蝇王"] = {
            en = "fruitfly",
            value = "default",
            type = "options5"
        },
        ["树精守卫"] = {
            en = "liefs",
            value = "default",
            type = "options5"
        },
        ["毒菌蟾蜍"] = {
            en = "toadstool",
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
