---- leveldataoverride.lua
---- worldgenoverride.lua
return {
background_node_range={ 0, 1 },
desc="探查洞穴…… 一起！",
hideminimap=false,
id="DST_CAVE", -- SURVIVAL_TOGETHER,MOD_MISSING,SURVIVAL_TOGETHER_CLASSIC,SURVIVAL_DEFAULT_PLUS,COMPLETE_DARKNESS,DST_CAVE,DST_CAVE_PLUS
location="cave",
max_playlist_position=999,
min_playlist_position=0,
name="洞穴",
numrandom_set_pieces=0,
override_level_string=false,

required_prefabs={ "multiplayer_portal" },
settings_desc="探查洞穴…… 一起！",
settings_id="DST_CAVE", -- SURVIVAL_TOGETHER,MOD_MISSING,SURVIVAL_TOGETHER_CLASSIC,SURVIVAL_DEFAULT_PLUS,COMPLETE_DARKNESS,DST_CAVE,DST_CAVE_PLUS
settings_name="洞穴",
substitutes={ },
version=4,
worldgen_desc="探查洞穴…… 一起！",
worldgen_id="DST_CAVE", -- SURVIVAL_TOGETHER,MOD_MISSING,SURVIVAL_TOGETHER_CLASSIC,SURVIVAL_DEFAULT_PLUS,COMPLETE_DARKNESS,DST_CAVE,DST_CAVE_PLUS
worldgen_name="洞穴",
overrides={
---------- ---------- ----------
-- 世界生成 - 世界
task_set="cave_default", -- 生物群落: classic,default,cave_default
start_location="caves", -- 出生点: caves,default,plus,darkness
world_size="medium", -- 世界大小: small,medium,default,huge
branching="default", -- 分支: never,least,default,most
loop="default", -- 环形: never,default,always
touchstone="default", -- 试金石: never,rare,uncommon,default,often,mostly,always,insane
cavelight="default", -- 洞穴光照: never,veryslow,slow,default,fast,veryfast
boons="default", -- 失败的冒险家: never,rare,uncommon,default,often,mostly,always,insane
prefabswaps_start="default", -- 开始资源多样化: classic,default,highly random

-- 世界生成 - 资源
grass="default", -- 草: never,rare,uncommon,default,often,mostly,always,insane
rock="default", -- 巨石: never,rare,uncommon,default,often,mostly,always,insane
sapling="default", -- 树苗: never,rare,uncommon,default,often,mostly,always,insane
cave_ponds="default", -- 池塘: never,rare,uncommon,default,often,mostly,always,insane
flint="default", -- 燧石: never,rare,uncommon,default,often,mostly,always,insane
reeds="default", -- 芦苇: never,rare,uncommon,default,often,mostly,always,insane
lichen="default", -- 苔藓: never,rare,uncommon,default,often,mostly,always,insane
mushroom="default", -- 蘑菇: never,rare,uncommon,default,often,mostly,always,insane
marshbush="insane", -- 尖灌木: never,rare,uncommon,default,often,mostly,always,insane
berrybush="insane", -- 浆果丛: never,rare,uncommon,default,often,mostly,always,insane
flower_cave="default", -- 荧光花: never,rare,uncommon,default,often,mostly,always,insane
mushtree="default", -- 蘑菇树: never,rare,uncommon,default,often,mostly,always,insane
wormlights="default", -- 发光浆果: never,rare,uncommon,default,often,mostly,always,insane
fern="default", -- 洞穴蕨类: never,rare,uncommon,default,often,mostly,always,insane
banana="default", -- 洞穴香蕉: never,rare,uncommon,default,often,mostly,always,insane
trees="default", -- 树(所有): never,rare,uncommon,default,often,mostly,always,insane

-- 世界生成 - 生物以及刷新点
bunnymen="default", -- 兔屋: never,rare,uncommon,default,often,mostly,always,insane
rocky="default", -- 石虾: never,rare,uncommon,default,often,mostly,always,insane
slurper="default", -- 缀食者: never,rare,uncommon,default,often,mostly,always,insane
monkey="default", -- 穴居猴桶: never,rare,uncommon,default,often,mostly,always,insane
slurtles="default", -- 蛞蝓龟窝: never,rare,uncommon,default,often,mostly,always,insane

-- 世界生成 - 敌对生物以及刷新点
bats="default", -- 蝙蝠: never,rare,uncommon,default,often,mostly,always,insane
tentacles="default", -- 触手: never,rare,uncommon,default,often,mostly,always,insane
cave_spiders="default", -- 蛛网岩: never,rare,uncommon,default,often,mostly,always,insane
spiders="default", -- 蜘蛛巢: never,rare,uncommon,default,often,mostly,always,insane
chess="default", -- 发条装置: never,rare,uncommon,default,often,mostly,always,insane
fissure="default", -- 梦魇裂隙: never,rare,uncommon,default,often,mostly,always,insane
worms="default", -- 洞穴蠕虫: never,rare,uncommon,default,often,mostly,always,insane

---------- ---------- ----------
-- 世界选项 - 世界
weather="default", -- 雨: never,rare,default,often,always
earthquakes="default", -- 地震: never,rare,default,often,always
atriumgate="default", -- 远古大门: never,rare,default,often,always
wormattacks="default", -- 洞穴蠕虫攻击: never,rare,default,often,always

-- 世界选项 - 资源再生
regrowth="default", -- 重生速度: never,veryslow,slow,default,fast,veryfast
flower_cave_regrowth="default", -- 荧光花: never,veryslow,slow,default,fast,veryfast
mushtree_regrowth="default", -- 蘑菇树: never,veryslow,slow,default,fast,veryfast
mushtree_moon_regrowth="default", -- 月亮蘑菇树: never,veryslow,slow,default,fast,veryfast
lightflier_flower_regrowth="default", -- 球状光虫花: never,veryslow,slow,default,fast,veryfast

-- 世界选项 - 生物
pigs_setting="default", -- 猪: never,rare,default,often,always
bunnymen_setting="default", -- 兔人: never,rare,default,often,always
dustmoths="default", -- 尘蛾: never,rare,default,often,always
rocky_setting="default", -- 石虾: never,rare,default,often,always
moles_setting="default", -- 鼹鼠: never,rare,default,often,always
monkey_setting="default", -- 穴居猴: never,rare,default,often,always
slurtles_setting="default", -- 蛞蝓龟: never,rare,default,often,always
snurtles="default", -- 蜗牛龟: never,rare,default,often,always
lightfliers="default", -- 球状光虫: never,rare,default,often,always
mushgnome="default", -- 蘑菇地精: never,rare,default,often,always
grassgekkos="never", -- 草壁虎转化: never,rare,default,often,always

-- 世界选项 - 敌对生物
spiders_setting="default", -- 蜘蛛: never,rare,default,often,always
bats_setting="default", -- 蝙蝠: never,rare,default,often,always
merms="default", -- 鱼人: never,rare,default,often,always
spider_spitter="default", -- 喷射蜘蛛: never,rare,default,often,always
spider_hider="default", -- 洞穴蜘蛛: never,rare,default,often,always
spider_dropper="default", -- 穴居悬蛛: never,rare,default,often,always
spider_warriors="default", -- 蜘蛛战士: never,default
nightmarecreatures="default", -- 遗迹梦魇: never,rare,default,often,always
molebats="default", -- 裸鼹鼠蝙蝠: never,rare,default,often,always

-- 世界选项 - 巨兽
fruitfly="default", -- 果蝇王: never,rare,default,often,always
liefs="default", -- 树精守卫: never,rare,default,often,always
toadstool="default", -- 毒菌蟾蜍: never,rare,default,often,always
spiderqueen="default", -- 蜘蛛女王: never,rare,default,often,always

---------- ---------- ----------
---- 出现在Master的设定
beefaloheat="default", -- 皮费娄牛交配频率: never,rare,default,often,always
brightmarecreatures="default", -- 启蒙怪兽: never,rare,default,often,always
dropeverythingondespawn="default", -- 离开游戏后物品掉落: default,always
extrastartingitems="default", -- 额外起始资源: 0,5,default,15,20,none
krampus="default", -- 坎普斯: never,rare,default,often,always
season_start="default", -- 起始季节: default,winter,spring,summer,autumnorspring,winterorsummer,random
seasonalstartingitems="default", -- 季节起始物品: never,default
shadowcreatures="default", -- 理智怪兽: never,rare,default,often,always
spawnprotection="default", -- 防骚扰出生保护: never,default,always
specialevent="default", -- 活动: none,default,hallowed_nights,winters_feast,year_of_the_gobbler,year_of_the_varg,year_of_the_pig,year_of_the_carrat,year_of_the_beefalo

---------- ---------- ----------
---- 其他
layout_mode="RestrictNodesByKey", -- ?
roads="never", -- ?
wormhole_prefab="tentacle_pillar" -- ?
}
}
