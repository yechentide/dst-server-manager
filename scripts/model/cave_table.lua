cave_generations_array = {"世界", "资源", "生物以及刷新点", "敌对生物以及刷新点"}
cave_generations_table = {
    [ [[世界]] ] = {
        [ [[生物群落]] ] = {
            en = "task_set",
            default = "cave_default",
            type = "biomecave"
        },
        [ [[出生点]] ] = {
            en = "start_location",
            default = "caves",
            type = "startlocationcave"
        },
        [ [[世界大小]] ] = {
            en = "world_size",
            default = "default",
            type = "worldsize"
        },
        [ [[分支]] ] = {
            en = "branching",
            default = "default",
            type = "branch"
        },
        [ [[环形]] ] = {
            en = "loop",
            default = "default",
            type = "loop"
        },
        [ [[试金石]] ] = {
            en = "touchstone",
            default = "default",
            type = "object02"
        },
        [ [[洞穴光照]] ] = {
            en = "cavelight",
            default = "default",
            type = "regrowthspeed"
        },
        [ [[失败的冒险家]] ] = {
            en = "boons",
            default = "default",
            type = "object02"
        },
        [ [[开始资源多样化]] ] = {
            en = "prefabswaps_start",
            default = "default",
            type = "prefabswapsstart"
        }
    },
    [ [[资源]] ] = {
        [ [[草]] ] = {
            en = "grass",
            default = "default",
            type = "object02"
        },
        [ [[巨石]] ] = {
            en = "rock",
            default = "default",
            type = "object02"
        },
        [ [[树苗]] ] = {
            en = "sapling",
            default = "default",
            type = "object02"
        },
        [ [[池塘]] ] = {
            en = "cave_ponds",
            default = "default",
            type = "object02"
        },
        [ [[燧石]] ] = {
            en = "flint",
            default = "default",
            type = "object02"
        },
        [ [[芦苇]] ] = {
            en = "reeds",
            default = "default",
            type = "object02"
        },
        [ [[苔藓]] ] = {
            en = "lichen",
            default = "default",
            type = "object02"
        },
        [ [[蘑菇]] ] = {
            en = "mushroom",
            default = "default",
            type = "object02"
        },
        [ [[尖灌木]] ] = {
            en = "marshbush",
            default = "default",
            type = "object02"
        },
        [ [[浆果丛]] ] = {
            en = "berrybush",
            default = "default",
            type = "object02"
        },
        [ [[荧光花]] ] = {
            en = "flower_cave",
            default = "default",
            type = "object02"
        },
        [ [[蘑菇树]] ] = {
            en = "mushtree",
            default = "default",
            type = "object02"
        },
        [ [[发光浆果]] ] = {
            en = "wormlights",
            default = "default",
            type = "object02"
        },
        [ [[洞穴蕨类]] ] = {
            en = "fern",
            default = "default",
            type = "object02"
        },
        [ [[洞穴香蕉]] ] = {
            en = "banana",
            default = "default",
            type = "object02"
        },
        [ [[树(所有)]] ] = {
            en = "trees",
            default = "default",
            type = "object02"
        }
    },
    [ [[生物以及刷新点]] ] = {
        [ [[兔屋]] ] = {
            en = "bunnymen",
            default = "default",
            type = "object02"
        },
        [ [[石虾]] ] = {
            en = "rocky",
            default = "default",
            type = "object02"
        },
        [ [[缀食者]] ] = {
            en = "slurper",
            default = "default",
            type = "object02"
        },
        [ [[穴居猴桶]] ] = {
            en = "monkey",
            default = "default",
            type = "object02"
        },
        [ [[蛞蝓龟窝]] ] = {
            en = "slurtles",
            default = "default",
            type = "object02"
        }
    },
    [ [[敌对生物以及刷新点]] ] = {
        [ [[蝙蝠]] ] = {
            en = "bats",
            default = "default",
            type = "object02"
        },
        [ [[触手]] ] = {
            en = "tentacles",
            default = "default",
            type = "object02"
        },
        [ [[蛛网岩]] ] = {
            en = "cave_spiders",
            default = "default",
            type = "object02"
        },
        [ [[蜘蛛巢]] ] = {
            en = "spiders",
            default = "default",
            type = "object02"
        },
        [ [[发条装置]] ] = {
            en = "chess",
            default = "default",
            type = "object02"
        },
        [ [[梦魇裂隙]] ] = {
            en = "fissure",
            default = "default",
            type = "object02"
        },
        [ [[洞穴蠕虫]] ] = {
            en = "worms",
            default = "default",
            type = "object02"
        }
    }
}

cave_settings_array = {"世界", "资源再生", "生物", "敌对生物", "巨兽"}
cave_settings_table = {
    [ [[世界]] ] = {
        [ [[雨]] ] = {
            en = "weather",
            default = "default",
            type = "object01"
        },
        [ [[地震]] ] = {
            en = "earthquakes",
            default = "default",
            type = "object01"
        },
        [ [[远古大门]] ] = {
            en = "atriumgate",
            default = "default",
            type = "object01"
        },
        [ [[洞穴蠕虫攻击]] ] = {
            en = "wormattacks",
            default = "default",
            type = "object01"
        }
    },
    [ [[资源再生]] ] = {
        [ [[重生速度]] ] = {
            en = "regrowth",
            default = "default",
            type = "regrowthspeed"
        },
        [ [[荧光花]] ] = {
            en = "flower_cave_regrowth",
            default = "default",
            type = "regrowthspeed"
        },
        [ [[蘑菇树]] ] = {
            en = "mushtree_regrowth",
            default = "default",
            type = "regrowthspeed"
        },
        [ [[月亮蘑菇树]] ] = {
            en = "mushtree_moon_regrowth",
            default = "default",
            type = "regrowthspeed"
        },
        [ [[球状光虫花]] ] = {
            en = "lightflier_flower_regrowth",
            default = "default",
            type = "regrowthspeed"
        }
    },
    [ [[生物]] ] = {
        [ [[猪]] ] = {
            en = "pigs_setting",
            default = "default",
            type = "object01"
        },
        [ [[兔人]] ] = {
            en = "bunnymen_setting",
            default = "default",
            type = "object01"
        },
        [ [[尘蛾]] ] = {
            en = "dustmoths",
            default = "default",
            type = "object01"
        },
        [ [[石虾]] ] = {
            en = "rocky_setting",
            default = "default",
            type = "object01"
        },
        [ [[鼹鼠]] ] = {
            en = "moles_setting",
            default = "default",
            type = "object01"
        },
        [ [[穴居猴]] ] = {
            en = "monkey_setting",
            default = "default",
            type = "object01"
        },
        [ [[蛞蝓龟]] ] = {
            en = "slurtles_setting",
            default = "default",
            type = "object01"
        },
        [ [[蜗牛龟]] ] = {
            en = "snurtles",
            default = "default",
            type = "object01"
        },
        [ [[球状光虫]] ] = {
            en = "lightfliers",
            default = "default",
            type = "object01"
        },
        [ [[蘑菇地精]] ] = {
            en = "mushgnome",
            default = "default",
            type = "object01"
        },
        [ [[草壁虎转化]] ] = {
            en = "grassgekkos",
            default = "never",
            type = "object01"
        }
    },
    [ [[敌对生物]] ] = {
        [ [[蜘蛛]] ] = {
            en = "spiders_setting",
            default = "default",
            type = "object01"
        },
        [ [[蝙蝠]] ] = {
            en = "bats_setting",
            default = "default",
            type = "object01"
        },
        [ [[鱼人]] ] = {
            en = "merms",
            default = "default",
            type = "object01"
        },
        [ [[喷射蜘蛛]] ] = {
            en = "spider_spitter",
            default = "default",
            type = "object01"
        },
        [ [[洞穴蜘蛛]] ] = {
            en = "spider_hider",
            default = "default",
            type = "object01"
        },
        [ [[穴居悬蛛]] ] = {
            en = "spider_dropper",
            default = "default",
            type = "object01"
        },
        [ [[蜘蛛战士]] ] = {
            en = "spider_warriors",
            default = "default",
            type = "spiderwarriors"
        },
        [ [[遗迹梦魇]] ] = {
            en = "nightmarecreatures",
            default = "default",
            type = "object01"
        },
        [ [[裸鼹鼠蝙蝠]] ] = {
            en = "molebats",
            default = "default",
            type = "object01"
        }
    },
    [ [[巨兽]] ] = {
        [ [[果蝇王]] ] = {
            en = "fruitfly",
            default = "default",
            type = "object01"
        },
        [ [[树精守卫]] ] = {
            en = "liefs",
            default = "default",
            type = "object01"
        },
        [ [[毒菌蟾蜍]] ] = {
            en = "toadstool",
            default = "default",
            type = "object01"
        },
        [ [[蜘蛛女王]] ] = {
            en = "spiderqueen",
            default = "default",
            type = "object01"
        }
    }
}
