return {
    baseid="SURVIVAL_SHIPWRECKED_CLASSIC",
    worldgen_preset = "SURVIVAL_SHIPWRECKED_CLASSIC",
    settings_preset = "SURVIVAL_SHIPWRECKED_CLASSIC",
    override_enabled = true,
    id="SURVIVAL_SHIPWRECKED_CLASSIC",
    name="Shipwrecked",
    desc="A world of (almost) exclusively Shipwrecked content.",
    worldgen_desc="A world of (almost) exclusively Shipwrecked content.",
    worldgen_id="SURVIVAL_SHIPWRECKED_CLASSIC",
    worldgen_name="Shipwrecked",
    settings_desc="A world of (almost) exclusively Shipwrecked content.",
    settings_id="SURVIVAL_SHIPWRECKED_CLASSIC",
    settings_name="Shipwrecked",
    required_prefabs={ "octopusking" },
    required_setpieces={  },
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
    random_set_pieces={  },
    --
    overrides={
        -- generations
        angrybees="default",
        beefalo="default",
        bees="default",
        berrybush="default",
        boons="default",
        branching="most",
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
        loop="always",
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
        prefabswaps_start="classic",
        rabbits="default",
        reeds="default",
        roads="never",
        rock="default",
        rock_ice="default",
        sapling="default",
        season_start="default",
        spiders="default",
        start_location="islandadventures",
        tallbirds="default",
        task_set="default",
        tentacles="default",
        terrariumchest="default",
        touchstone="default",
        trees="default",
        tumbleweed="default",
        walrus="default",
        world_size="default",

        ---------- ---------- ---------- ---------- ----------
        ---------- ----------    海难    ---------- ----------
        ---------- ---------- ---------- ---------- ----------
        -- generations - Island世界 9
        primaryworldtype="islandsonly",     -- default, merged, islandsonly
        islandquantity="small",             -- (worldsize)
        volcano="default",                  -- (defaultnever)
        dragoonegg="default",               -- (options5)
        tides="default",                    -- (defaultnever)
        floods="default",                   -- (options5)
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