return {
    id="VOLCANO_LEVEL",
    name="Volcano",
    desc="The top of the SW volcano",
    worldgen_desc="The top of the SW volcano",
    worldgen_id="VOLCANO_LEVEL",
    worldgen_name="Volcano",
    settings_desc="The top of the SW volcano",
    settings_id="VOLCANO_LEVEL",
    settings_name="Volcano",
    required_prefabs={ "volcano_altar", "obsidian_workbench", "volcano_start" },
    required_setpieces={ "ObsidianWorkbench", "VolcanoStart", "VolcanoAltar" },
    --
    version=2,
    hideminimap=false,
    location="forest",
    max_playlist_position=999,
    min_playlist_position=0,
    numrandom_set_pieces=0,
    override_level_string=false,
    substitutes={  },
    --
    background_node_range={ 0, 0 },
    --
    overrides={
        -- generations
        angrybees="default",
        beefalo="default",
        bees="default",
        berrybush="default",
        boons="never",
        branching="default",
        buzzard="default",
        cactus="default",
        carrot="default",
        catcoon="default",
        chess="default",
        flint="default",
        flowers="default",
        grass="default",
        houndmound="default",
        lightninggoat="default",
        loop="default",
        marshbush="default",
        merm="default",
        meteorspawner="default",
        moles="default",
        moon_berrybush="default",
        moon_bullkelp="default",
        moon_carrot="default",
        moon_fissure="default",
        moon_fruitdragon="default",
        moon_hotspring="default",
        moon_rock="default",
        moon_sapling="default",
        moon_spiders="default",
        moon_starfish="default",
        moon_tree="default",
        mushroom="default",
        ocean_bullkelp="default",
        ocean_seastack="ocean_default",
        ocean_shoal="default",
        ocean_waterplant="ocean_default",
        ocean_wobsterden="default",
        pigs="default",
        ponds="default",
        prefabswaps_start="default",
        rabbits="default",
        reeds="default",
        roads="never",
        rock="default",
        rock_ice="default",
        sapling="default",
        season_start="default",
        spiders="default",
        start_location="VolcanoDoor",
        tallbirds="default",
        task_set="volcanoset",
        tentacles="default",
        terrariumchest="default",
        touchstone="default",
        trees="default",
        tumbleweed="default",
        walrus="default",
        world_size="small",

        ---------- ---------- ---------- ---------- ----------
        --------------------     火山    ---------- ----------
        ---------- ---------- ---------- ---------- ----------

        isvolcano="yes",
        location="forest",
        loop_percent="always",
        poi="never",
        protected="never",
        traps="never",

        ---------- ---------- ----------
        -- generations - Island世界 9
        primaryworldtype="islandsonly",     -- default, merged, islandsonly
        islandquantity="default",           -- (worldsize)
        volcano="default",                  -- (defaultnever)
        dragoonegg="default",               -- (options5)
        tides="default",                    -- (defaultnever)
        floods="never",                     -- (options5)
        oceanwaves="default",               -- never, rare, veryrare, default, often, always
        poison="default",                   -- (defaultnever)
        bermudatriangle="default",          -- (options5)
        -- generations - Island食物 3
        sweet_potato="default",             -- (options5)
        limpets="default",                  -- (options5)
        mussel_farm="default",              -- (options5)

        ---------- ---------- ---------- ---------- ----------
        -- 其他
        -- has_ocean=true,
        -- keep_disconnected_tiles=true,
        -- layout_mode="LinkNodesByKeys",
        -- no_joining_islands=true,
        -- no_wormholes_to_disconnected_tiles=true,
        -- worldseed="",
        -- wormhole_prefab="wormhole",
    }
}