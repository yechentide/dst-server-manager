#!/usr/bin/env lua
-- arg[1]: $repo_root_dir       --> ~/DSTServerManager
-- arg[2]: action               --> new / update / convert
-- arg[3]: shard dir path       --> ~/Klei/worlds/c01/Main
-- arg[4]: world type           --> forest / cave / shipwrecked / volcano
-- arg[5]: setting file         --> 默认worldgenoverride, 或者传递leveldataoverride

package.path = package.path..';'..arg[1]..'/lib/?.lua;'..arg[1]..'/lib/models/?.lua;'

WORLD_PRESETS_DIR = arg[1].."/templates/world_presets"
shipwrecked = false
if arg[4] == "shipwrecked" or arg[4] == "volcano" then shipwrecked = true end
setting_file = "worldgenoverride.lua"
if arg[5] == "leveldataoverride.lua" then setting_file = "leveldataoverride.lua" end

require("utils")
require("table_forest")
require("table_cave")
require("value_types_world")

----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------

-- Return: new model
function update_model_from_file(old_model, new_file_path)
    local new_data = dofile(new_file_path)
    local new_table = new_data["overrides"]

    local group_array = old_model["array"]
    for _, group_name in ipairs(group_array) do
        local option_array = old_model[group_name]["array"]
        for _, option_name in ipairs(option_array) do
            local key = old_model[group_name][option_name]["key"]
            local old_value = old_model[group_name][option_name]["value"]
            local new_value = new_table[key]
            if new_value ~= nil and new_value ~= old_value then
                --print(string.format("%s: %s --> %s", key, old_value, new_value))
                old_model[group_name][option_name]["value"] = new_value
            end
        end
    end
    return old_model
end

function apply_changes_to_file(table, file_path)
    local old_data = dofile(file_path)
    local old_table = old_data["overrides"]

    local group_array = table["array"]
    for _, group_name in ipairs(group_array) do
        local option_array = table[group_name]["array"]
        for _, option_name in ipairs(option_array) do
            local key = table[group_name][option_name]["key"]
            local new_value = table[group_name][option_name]["value"]
            local old_value = old_table[key]
            if old_value ~= nil and old_value ~= new_value then
                --print(string.format("%s:\t\t\t%s ---> %s", en, old_value, new_value))
                local command = "sed -i -e \"s/ "..key.."=\\\""..old_value.."\\\"/ "..key.."=\\\""..new_value.."\\\"/g\" "..file_path
                --print(command)
                os.execute(command)
            end
        end
    end
end

function generate_worldgenoverride(file_path, model_generation, model_setting, is_overground)
    os.execute("echo '' > "..file_path)
    os.execute("sed -i -e '$i return {' "..file_path)

    if not is_overground then
        os.execute("sed -i -e '$i \\    worldgen_preset = \"DST_CAVE\",' "..file_path)
        os.execute("sed -i -e '$i \\    settings_preset = \"DST_CAVE\",' "..file_path)
    end
    os.execute("sed -i -e '$i \\    override_enabled = true,' "..file_path)
    os.execute("sed -i -e '$i \\    overrides={' "..file_path)

    local model_list = {model_generation, model_setting}
    for i, model in ipairs(model_list) do
        local type_comment = "generations"
        if i == 2 then type_comment = "settings" end
        os.execute("sed -i -e '$i \\        -- "..type_comment.."' "..file_path)
        for _, group_name in pairs(model["array"]) do
            for _, option_name in ipairs(model[group_name]["array"]) do
                local key = model[group_name][option_name]["key"]
                local value = model[group_name][option_name]["value"]
                if type(value) == "string" then value = "\""..value.."\"" end
                os.execute("sed -i -e '$i \\        "..key.."="..tostring(value)..",' "..file_path)
            end
        end
    end

    os.execute("sed -i -e '$i \\    }' "..file_path)
    os.execute("sed -i -e '$i }' "..file_path)
end

function configure_model(table, prefix, is_generation)
    local group_array = table["array"]
    for _, group_name in ipairs(group_array) do
        while true do
            clear()
            print_divider("-", 36)
            if is_generation then
                color_print("warn", "以下是生成世界时的设置，生成后将无法修改！", true)
            else
                color_print("info", "以下是世界选项，世界生成后也可以修改生效！", true)
            end
            print()
            color_print(36, prefix..group_name, true)

            local option_array = table[group_name]["array"]
            for _, option_name in ipairs(option_array) do
                local value_type = table[group_name][option_name]["type"]
                local current_value_en = table[group_name][option_name]["value"]
                local current_value_zh = translate_2zh(world_value_types, value_type, current_value_en)
                --sleepms(0.1)
                print(string.format("    %s = %s", option_name, current_value_zh))
            end

            local answer = confirm("info", "是否有需要修改的？")
            if answer == false then break end

            local target = select_one(option_array, "info", "请选一个选项", true)
            if target == "返回" then break end

            local value_type = table[group_name][target]["type"]
            local value_options = world_value_types[value_type]["zh"]
            local new_value = select_one(value_options, "info", "请选一个选项", true)
            if new_value == "返回" then break end

            table[group_name][target]["value"] = translate_2key(world_value_types, value_type, new_value)
        end
    end
end

-- Return: 某个preset的文件夹的路径
function select_preset()
    local presets_dir_path = arg[1].."/templates/world_presets"
    local result = exec_linux_command_get_output("ls "..presets_dir_path)
    local presets = split(result, "\n")
    local answer = select_one(presets, "info", "请选择一个模板")
    return arg[1].."/templates/world_presets/"..answer
end

----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------
-- 新建世界时, 会由Shell脚本来复制worldgenoverride.lua到制定文件夹, 然后执行本脚本更改设置
-- 新建世界或者更改选项, 流程都是: 读取model, 更新model, 展示model, 保存model

function generate_new(shard_dir_path, is_overground)
    clear()
    print_divider("-", 36)
    color_print("info", "开始配置世界！", true)

    -- 读取model, 更新model
    local model_gen = {}
    local model_set = {}
    local file_gen = ""
    local file_set = ""
    color_print("tip", "standard是游戏里的默认配置, terraria是游戏里的泰拉瑞亚配置", true)
    color_print("tip", "这两个模板里的草蜥蜴和多枝树均已关闭", true)
    local preset_dir_path = select_preset()

    color_print("info", "接下来会列出各个配置列表, 请按需求修改 ", false); count_down(3, false)
    if is_overground then
        model_gen = forest_generations_table
        model_set = forest_settings_table
        file_gen = "/forest_gen.lua"
        file_set = "/forest_set.lua"
    else
        model_gen = cave_generations_table
        model_set = cave_settings_table
        file_gen = "/cave_gen.lua"
        file_set = "/cave_set.lua"
    end
    update_model_from_file(model_gen, preset_dir_path..file_gen)
    update_model_from_file(model_set, preset_dir_path..file_set)

    -- 展示model
    local title_gen = ""
    local title_set = ""
    local answer = ""
    if is_overground then
        title_gen = "地上 - 生成 - "
        title_set = "地上 - 选项 - "
    else
        title_gen = "洞穴 - 生成 - "
        title_set = "洞穴 - 选项 - "
    end
    clear()
    print_divider("-", 36)
    if confirm("info", "即将开始修改 \"世界生成\" 配置, 是否跳过?") == false then
        configure_model(model_gen, title_gen, true)
    end
    clear()
    print_divider("-", 36)
    if confirm("info", "即将开始修改 \"世界选项\" 配置, 是否跳过?") == false then
        configure_model(model_set, title_set, false)
    end

    -- 保存model
    local file_path = shard_dir_path.."/"..setting_file
    generate_worldgenoverride(file_path, model_gen, model_set, is_overground)

    -- 保存为新模板
    clear()
    print_divider("-", 36)
    if confirm("info", "是否要把当前设置保存为新的模板?") == true then
        local default_presets = {standard = true, terraria = true, empty = true}
        while true do
            local name = readline(false, "info", "请输入新模板的名字")
            if default_presets[name] ~= nil then
                color_print("error", "该名字和默认模板同名!", true)
            else
                local new_preset_path = WORLD_PRESETS_DIR.."/"..name
                if file_exist(new_preset_path) == false then
                    copy_file(WORLD_PRESETS_DIR.."/standard", new_preset_path, true)
                    color_print("tip", "新模板文件位于 "..WORLD_PRESETS_DIR, true)
                    color_print("tip", "保存新模板时选择已有模板, 就可以更新模板。(默认模板无法修改)", true)
                end
                apply_changes_to_file(model_gen, new_preset_path..file_gen)
                apply_changes_to_file(model_set, new_preset_path..file_set)
                sleep(3)
                break
            end
        end
    end

    clear()
    color_print("success", "世界配置完成！", true)
    print_divider("-", 36)
end

function change_options(shard_dir_path, is_overground)
    clear()
    print_divider("-", 36)
    color_print("info", "开始配置世界！", true)
    color_print("info", "接下来会列出各个配置列表, 请按需求修改 ", false); count_down(3, false)

    -- 读取model, 更新model
    local model_set = {}
    if is_overground then
        model_set = forest_settings_table
    else
        model_set = cave_settings_table
    end
    update_model_from_file(model_set, shard_dir_path.."/"..setting_file)

    -- 展示model
    if is_overground then
        configure_model(model_set, "地上 - 选项 - ", false)
    else
        configure_model(model_set, "洞穴 - 选项 - ", false)
    end

    -- 保存model
    apply_changes_to_file(model_set, shard_dir_path.."/"..setting_file)

    clear()
    color_print("success", "世界配置完成！", true)
    print_divider("-", 36)
end

function convert(old_file_path, new_file_path, is_overground)
    local model_gen = {}
    local model_set = {}
    if is_overground == "true" then
        model_gen = forest_generations_table
        model_set = forest_settings_table
    else
        model_gen = cave_generations_table
        model_set = cave_settings_table
    end
    update_model_from_file(model_gen, old_file_path)
    update_model_from_file(model_set, old_file_path)

    generate_worldgenoverride(new_file_path, model_gen, model_set, is_overground == "true")
end

if arg[2] == 'new' then
    -- 命令行指令例子:  lua ./configure_world.lua /home/tide/DSTServerManager new $shard_path 'forest'
    local is_forest = true
    if arg[4] ~= "forest" then is_forest = false end
    generate_new(arg[3], is_forest)
elseif arg[2] == 'update' then
    -- 命令行指令例子:  lua ./configure_world.lua /home/tide/DSTServerManager update $shard_path 'forest'
    local is_forest = true
    if arg[4] ~= "forest" then is_forest = false end
    change_options(arg[3], is_forest)
elseif arg[2] == 'convert' then
    -- arg[3]: old worldgenoverride
    -- arg[4]: new worldgenoverride
    -- arg[5]: 'true' / 'false'
    convert(arg[3], arg[4], arg[5])
end
