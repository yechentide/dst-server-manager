return {
    --?- desc="标准《饥荒》体验。",
    --?- hideminimap=false,
    --?- id="SURVIVAL_TOGETHER",                         -- SURVIVAL_TOGETHER,MOD_MISSING,SURVIVAL_TOGETHER_CLASSIC,SURVIVAL_DEFAULT_PLUS,COMPLETE_DARKNESS,DST_CAVE,DST_CAVE_PLUS
    --?- location="forest",
    --?- max_playlist_position=999,
    --?- min_playlist_position=0,
    name="~~ 标准森林 ~~",
    --?- numrandom_set_pieces=4,
    --?- override_level_string=false,

    --?- required_prefabs={ "multiplayer_portal" },
    --?- required_setpieces={ "Sculptures_1,Maxwell5" },
    --?- settings_desc="标准《饥荒》体验。",
    --?- settings_id="SURVIVAL_TOGETHER",                -- SURVIVAL_TOGETHER,MOD_MISSING,SURVIVAL_TOGETHER_CLASSIC,SURVIVAL_DEFAULT_PLUS,COMPLETE_DARKNESS,DST_CAVE,DST_CAVE_PLUS
    --?- settings_name="标准森林",
    --?- substitutes={  },
    --?- version=4,
    --?- worldgen_desc="标准《饥荒》体验。",
    --?- worldgen_id="SURVIVAL_TOGETHER",                -- SURVIVAL_TOGETHER,MOD_MISSING,SURVIVAL_TOGETHER_CLASSIC,SURVIVAL_DEFAULT_PLUS,COMPLETE_DARKNESS,DST_CAVE,DST_CAVE_PLUS
    --?- worldgen_name="标准森林",
    --?- random_set_pieces={
    --?-    "Sculptures_2",
    --?-    "Sculptures_3",
    --?-    "Sculptures_4",
    --?-    "Sculptures_5",
    --?-    "Chessy_1",
    --?-    "Chessy_2",
    --?-    "Chessy_3",
    --?-    "Chessy_4",
    --?-    "Chessy_5",
    --?-    "Chessy_6",
    --?-    "Maxwell1",
    --?-    "Maxwell2",
    --?-    "Maxwell3",
    --?-    "Maxwell4",
    --?-    "Maxwell6",
    --?-    "Maxwell7",
    --?-    "Warzone_1",
    --?-    "Warzone_2",
    --?-    "Warzone_3"
    --?- },
    override_enabled = true,
    overrides={
    ---------- ---------- ----------
    -- 世界生成 - 全局
        season_start="default",                     -- 起始季节: default,winter,spring,summer,autumnorspring,winterorsummer,random

    -- 世界生成 - 世界
        task_set="default",                         -- 生物群落: classic,default,cave_default
        start_location="default",                   -- 出生点: caves,default,plus,darkness
        world_size="medium",                        -- 世界大小: small,medium,default,huge
        branching="default",                        -- 分支: never,least,default,most,random
        loop="default",                             -- 环形: never,default,always
        touchstone="default",                       -- 试金石: never,rare,uncommon,default,often,mostly,always,insane
        boons="default",                            -- 失败的冒险家: never,rare,uncommon,default,often,mostly,always,insane
        prefabswaps_start="default",                -- 开始资源多样化: classic,default,highly random
        moon_fissure="default",                     -- 天体裂隙: never,rare,uncommon,default,often,mostly,always,insane
        terrariumchest="default",                   -- 泰拉瑞亚: never,default

    -- 世界生成 - 资源
        grass="default",                            -- 草: never,rare,uncommon,default,often,mostly,always,insane
        rock="default",                             -- 巨石: never,rare,uncommon,default,often,mostly,always,insane
        moon_tree="default",                        -- 月树: never,rare,uncommon,default,often,mostly,always,insane
        sapling="default",                          -- 树苗: never,rare,uncommon,default,often,mostly,always,insane
        ponds="default",                            -- 池塘: never,rare,uncommon,default,often,mostly,always,insane
        ocean_seastack="ocean_default",             -- 浮堆: never,rare,uncommon,default,often,mostly,always,insane
        moon_starfish="default",                    -- 海星: never,rare,uncommon,default,often,mostly,always,insane
        moon_hotspring="default",                   -- 温泉: never,rare,uncommon,default,often,mostly,always,insane
        flint="default",                            -- 燧石: never,rare,uncommon,default,often,mostly,always,insane
        reeds="default",                            -- 芦苇: never,rare,uncommon,default,often,mostly,always,insane
        mushroom="default",                         -- 蘑菇: never,rare,uncommon,default,often,mostly,always,insane
        cactus="default",                           -- 仙人掌: never,rare,uncommon,default,often,mostly,always,insane
        marshbush="default",                        -- 尖灌木: never,rare,uncommon,default,often,mostly,always,insane
        moon_rock="default",                        -- 月亮石: never,rare,uncommon,default,often,mostly,always,insane
        berrybush="default",                        -- 浆果丛: never,rare,uncommon,default,often,mostly,always,insane
        carrot="default",                           -- 胡萝卜: never,rare,uncommon,default,often,mostly,always,insane
        tumbleweed="default",                       -- 风滚草: never,rare,uncommon,default,often,mostly,always,insane
        ocean_bullkelp="default",                   -- 公牛海带: never,rare,uncommon,default,often,mostly,always,insane
        moon_sapling="default",                     -- 月亮树苗: never,rare,uncommon,default,often,mostly,always,insane
        meteorspawner="default",                    -- 流星区域: never,rare,uncommon,default,often,mostly,always,insane
        rock_ice="default",                         -- 迷你冰川: never,rare,uncommon,default,often,mostly,always,insane
        trees="default",                            -- 树(所有): never,rare,uncommon,default,often,mostly,always,insane
        moon_berrybush="default",                   -- 石果灌木丛: never,rare,uncommon,default,often,mostly,always,insane
        flowers="default",                          -- 花，邪恶花: never,rare,uncommon,default,often,mostly,always,insane
        moon_bullkelp="default",                    -- 海岸公牛海带: never,rare,uncommon,default,often,mostly,always,insane

    -- 世界生成 - 生物以及刷新点
        rabbits="default",                          -- 兔洞: never,rare,uncommon,default,often,mostly,always,insane
        pigs="default",                             -- 猪屋: never,rare,uncommon,default,often,mostly,always,insane
        buzzard="default",                          -- 秃鹫: never,rare,uncommon,default,often,mostly,always,insane
        ocean_shoal="default",                      -- 鱼群: never,rare,uncommon,default,often,mostly,always,insane
        lightninggoat="default",                    -- 伏特羊: never,rare,uncommon,default,often,mostly,always,insane
        moles="default",                            -- 鼹鼠洞: never,rare,uncommon,default,often,mostly,always,insane
        ocean_wobsterden="default",                 -- 龙虾窝: never,rare,uncommon,default,often,mostly,always,insane
        moon_fruitdragon="default",                 -- 沙拉蝾螈: never,rare,uncommon,default,often,mostly,always,insane
        beefalo="default",                          -- 皮费娄牛: never,rare,uncommon,default,often,mostly,always,insane
        catcoon="default",                          -- 空心树桩: never,rare,uncommon,default,often,mostly,always,insane
        moon_carrot="default",                      -- 胡萝卜鼠: never,rare,uncommon,default,often,mostly,always,insane
        bees="default",                             -- 蜜蜂蜂窝: never,rare,uncommon,default,often,mostly,always,insane

    -- 世界生成 - 敌对生物以及刷新点
        ocean_waterplant="ocean_default",           -- 海草: ocean_never,ocean_rare,ocean_uncommon,ocean_default,ocean_often,ocean_mostly,ocean_always,ocean_insane
        tentacles="default",                        -- 触手: never,rare,uncommon,default,often,mostly,always,insane
        houndmound="default",                       -- 猎犬丘: never,rare,uncommon,default,often,mostly,always,insane
        spiders="default",                          -- 蜘蛛巢: never,rare,uncommon,default,often,mostly,always,insane
        tallbirds="default",                        -- 高脚鸟: never,rare,uncommon,default,often,mostly,always,insane
        chess="default",                            -- 发条装置: never,rare,uncommon,default,often,mostly,always,insane
        walrus="default",                           -- 海象营地: never,rare,uncommon,default,often,mostly,always,insane
        angrybees="default",                        -- 杀人蜂蜂窝: never,rare,uncommon,default,often,mostly,always,insane
        merm="default",                             -- 漏雨的小屋: never,rare,uncommon,default,often,mostly,always,insane
        moon_spiders="default",                     -- 破碎蜘蛛洞: never,rare,uncommon,default,often,mostly,always,insane

    ---------- ---------- ----------
    -- 世界选项 - 全局
        specialevent="default",                     -- 活动: none,default,hallowed_nights,winters_feast,year_of_the_gobbler,year_of_the_varg,year_of_the_pig,year_of_the_carrat,year_of_the_beefalo
        spring="default",                           -- 春: noseason,veryshortseason,shortseason,default,longseason,verylongseason,random
        summer="default",                           -- 夏: noseason,veryshortseason,shortseason,default,longseason,verylongseason,random
        autumn="default",                           -- 秋: noseason,veryshortseason,shortseason,default,longseason,verylongseason,random
        winter="default",                           -- 冬: noseason,veryshortseason,shortseason,default,longseason,verylongseason,random
        day="default",                              -- 昼夜选项: default,longday,longdusk,longnight,noday,nodusk,nonight,onlyday,onlydusk,onlynight
        beefaloheat="default",                      -- 皮费娄牛交配频率: never,rare,default,often,always
        krampus="default",                          -- 坎普斯: never,rare,default,often,always

    -- 世界选项 - 冒险家
        extrastartingitems="default",               -- 额外起始资源: 0,5,default,15,20,none
        seasonalstartingitems="default",            -- 季节起始物品: never,default
        spawnprotection="default",                  -- 防骚扰出生保护: never,default,always
        dropeverythingondespawn="always",           -- 离开游戏后物品掉落: default,always
        brightmarecreatures="default",              -- 启蒙怪兽: never,rare,default,often,always
        shadowcreatures="default",                  -- 理智怪兽: never,rare,default,often,always

    -- 世界选项 - 世界
        weather="default",                          -- 雨: never,rare,default,often,always
        hunt="default",                             -- 狩猎: never,rare,default,often,always
        wildfires="default",                        -- 野火: never,rare,default,often,always
        lightning="default",                        -- 闪电: never,rare,default,often,always
        frograin="default",                         -- 青蛙雨: never,rare,default,often,always
        petrification="default",                    -- 森林石化: none,few,default,many,max
        meteorshowers="default",                    -- 流星频率: never,rare,default,often,always
        hounds="default",                           -- 猎犬袭击: never,rare,default,often,always
        alternatehunt="default",                    -- 追猎惊喜: never,rare,default,often,always

    -- 世界选项 - 资源再生
        regrowth="default",                         -- 重生速度: never,veryslow,slow,default,fast,veryfast
        flowers_regrowth="default",                 -- 花: nerver,veryslow,slow,default,fast,veryfast
        moon_tree_regrowth="default",               -- 月树: nerver,veryslow,slow,default,fast,veryfast
        saltstack_regrowth="default",               -- 盐堆: nerver,veryslow,slow,default,fast,veryfast
        twiggytrees_regrowth="never",               -- 多枝树: nerver,veryslow,slow,default,fast,veryfast
        evergreen_regrowth="default",               -- 常青树: nerver,veryslow,slow,default,fast,veryfast
        deciduoustree_regrowth="default",           -- 桦栗树: nerver,veryslow,slow,default,fast,veryfast
        carrots_regrowth="default",                 -- 胡萝卜: nerver,veryslow,slow,default,fast,veryfast

    -- 世界选项 - 生物
        pigs_setting="default",                     -- 猪: never,rare,default,often,always
        birds="default",                            -- 鸟: never,rare,default,often,always
        penguins="default",                         -- 企鹅: never,rare,default,often,always
        bunnymen_setting="default",                 -- 兔人: never,rare,default,often,always
        rabbits_setting="default",                  -- 兔子: never,rare,default,often,always
        catcoons="default",                         -- 浣猫: never,rare,default,often,always
        perd="default",                             -- 火鸡: never,rare,default,often,always
        bees_setting="default",                     -- 蜜蜂: never,rare,default,often,always
        butterfly="default",                        -- 蝴蝶: never,rare,default,often,always
        fishschools="default",                      -- 鱼群: never,rare,default,often,always
        moles_setting="default",                    -- 鼹鼠: never,rare,default,often,always
        wobsters="default",                         -- 龙虾: never,rare,default,often,always
        gnarwail="default",                         -- 一角鲸: never,rare,default,often,always
        grassgekkos="never",                        -- 草壁虎转化: never,rare,default,often,always

    -- 世界选项 - 敌对生物
        walrus_setting="default",                   -- 海象: never,rare,default,often,always
        hound_mounds="default",                     -- 猎犬: never,rare,default,often,always
        mosquitos="default",                        -- 蚊子: never,rare,default,often,always
        spiders_setting="default",                  -- 蜘蛛: never,rare,default,often,always
        bats_setting="default",                     -- 蝙蝠: never,rare,default,often,always
        frogs="default",                            -- 青蛙: never,rare,default,often,always
        merms="default",                            -- 鱼人: never,rare,default,often,always
        squid="default",                            -- 鱿鱼: never,rare,default,often,always
        sharks="default",                           -- 鲨鱼: never,rare,default,often,always
        wasps="default",                            -- 杀人蜂: never,rare,default,often,always
        lureplants="default",                       -- 食人花: never,rare,default,often,always
        mutated_hounds="default",                   -- 恐怖猎犬: never,rare,default,often,always
        penguins_moon="default",                    -- 月石企鹅: never,rare,default,often,always
        moon_spider="default",                      -- 破碎蜘蛛: never,rare,default,often,always
        spider_warriors="default",                  -- 蜘蛛战士: never,rare,default,often,always
        cookiecutters="default",                    -- 饼干切割机: never,rare,default,often,always

    -- 世界选项 - 巨兽
        bearger="default",                          -- 熊獾: never,rare,default,often,always
        beequeen="default",                         -- 蜂后: never,rare,default,often,always
        dragonfly="default",                        -- 龙蝇: never,rare,default,often,always
        klaus="default",                            -- 克劳斯: never,rare,default,often,always
        crabking="default",                         -- 帝王蟹: never,rare,default,often,always
        fruitfly="default",                         -- 果蝇王: never,rare,default,often,always
        malbatross="default",                       -- 邪天翁: never,rare,default,often,always
        goosemoose="default",                       -- 麋鹿鹅: never,rare,default,often,always
        eyeofterror="default",                      -- 恐怖之眼: never,rare,default,often,always
        liefs="default",                            -- 树精守卫: never,rare,default,often,always
        deciduousmonster="default",                 -- 毒桦栗树: never,rare,default,often,always
        deerclops="default",                        -- 独眼巨鹿: never,rare,default,often,always
        antliontribute="default",                   -- 蚁狮: never,rare,default,often,always
        spiderqueen="default",                      -- 蜘蛛女王: never,rare,default,often,always

    ---------- ---------- ----------
    -->> 其他
        has_ocean=true,                             -- ?
        keep_disconnected_tiles=true,               -- ?
        layout_mode="LinkNodesByKeys",              -- ?
        no_joining_islands=true,                    -- ?
        no_wormholes_to_disconnected_tiles=true,    -- ?
        roads="default",                            -- ?
        wormhole_prefab="wormhole"                  -- ?
    }
}
