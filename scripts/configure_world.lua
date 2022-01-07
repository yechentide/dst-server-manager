#!/usr/bin/env lua
-- arg[1]: $repo_root_dir  -->  /home/tide/DSTServerManager

-- arg[2]: $destination    -->  /home/tide/Klei/worlds/cluster/Main/worldgenoverride.lua
package.path = package.path..';'..arg[1]..'/scripts/?.lua;'..';'..arg[1]..'/scripts/model/?.lua;'..arg[1]..'/templates/?.lua;'
require("utils")
require("value_types")
require("main_table")
require("cave_table")

local temp_file_path_main = arg[1].."/templates/server_main.lua"
local temp_file_path_cave = arg[1].."/templates/server_cave.lua"

-- Return: new model
function update_model_from_file(old_model, new_file_path)
    local new_data = dofile(new_file_path)
    local new_table = new_data["overrides"]

    for group, child_table in pairs(old_model) do
        for zhkey, table in pairs(child_table) do
            local en = table["en"]
            local old_value = table["default"]
            local new_value = new_table[en]
            --print(string.format("%s: %s --> %s", en, old_value, new_value))
            if new_value ~= nil and new_value ~= old_value then
                table["default"] = new_value
            end
        end
    end

    return old_model
end

function display_model(array, table, prefix, is_generation)
    for i, key in ipairs(array) do
        while true do
            clear()
            print_divider("-", 36)
            if is_generation then
                color_print("warn", "以下是生成世界时的设置，生成后将无法修改！", true)
            else
                color_print("info", "以下是世界选项，世界生成后也可以修改生效！", true)
            end
            print()

            color_print(36, prefix..key, true)
            for k, v in pairs(table[key]) do
                local current_option = value_en2zh(v["type"], v["default"])
                --sleepms(0.1)
                print(string.format("    %s = %s", k, current_option))
            end
            local answer = yes_or_no("info", "是否有需要修改的？")
            
            if answer then
                local group_table = table[key]
                local target = select_one(get_keys(group_table))
                local value_type = group_table[target]["type"]
                local value_options = value_types[value_type]["zh"]
                local new_value = select_one(value_options)
                group_table[target]["default"] = value_zh2en(value_type, new_value)
            else
                break
            end

            print()
        end
    end
end

function apply_changes_to_file(table, file_path)
    local old_data = dofile(file_path)
    local old_table = old_data["overrides"]

    for group, child_table in pairs(table) do
        for zhkey, table in pairs(child_table) do
            local en = table["en"]
            local new_value = table["default"]
            local old_value = old_table[en]

            if old_value ~= nil and old_value ~= new_value then
                --print(string.format("%s:\t\t\t%s ---> %s", en, old_value, new_value))
                local command = "sed -i -e \"s/"..en.."=\\\""..old_value.."\\\"/"..en.."=\\\""..new_value.."\\\"/g\" "..file_path
                --print(command)
                os.execute(command)
            end
        end
    end
end

function configure_shard(shard_path, is_main, is_update)
    local destination_path = shard_path.."/worldgenoverride.lua"
    if not file_exist(destination_path) then
        if is_main then
            copy_file(arg[1].."/templates/server_main.lua", destination_path)
        else
            copy_file(arg[1].."/templates/server_cave.lua", destination_path)
        end
    end

    local model = {}
    local group_name_array = {}

    if is_main then
        if is_update then
            model = update_model_from_file(main_settings_table, destination_path)
        else
            model = main_generations_table
            group_name_array = main_generations_array
            display_model(group_name_array, model, "地上世界 - 生成设置 - ", true)
            apply_changes_to_file(model, destination_path)
            model = main_settings_table
        end
        
        group_name_array = main_settings_array
        display_model(group_name_array, model, "地上世界 - 选项设置 - ", false)
        apply_changes_to_file(model, destination_path)
    else
        if is_update then
            model = update_model_from_file(cave_settings_table, destination_path)
        else
            model = cave_generations_table
            group_name_array = cave_generations_array
            display_model(group_name_array, model, "地底世界 - 生成设置 - ", true)
            apply_changes_to_file(model, destination_path)
            model = cave_settings_table
        end
        
        group_name_array = cave_settings_array
        display_model(group_name_array, model, "地底世界 - 选项设置 - ", false)
        apply_changes_to_file(model, destination_path)
    end
end

----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------

function generate_new(cluster_path, has_main, has_cave, main_dir_name, cave_dir_name)
    clear()
    print_divider("-", 36)
    color_print("info", "开始配置世界！", true)
    color_print("info", "接下来会列出各个配置列表, 请按需求修改 ", false); count_down(3, false)

    if has_main == "true" then configure_shard(cluster_path.."/"..main_dir_name, true, false) end
    if has_cave == "true" then configure_shard(cluster_path.."/"..cave_dir_name, false, false) end

    clear()
    color_print("success", "世界配置完成！", true)
    print_divider("-", 36)
end

function change_options(shard_path, is_main)
    clear()
    print_divider("-", 36)
    color_print("info", "开始配置世界！", true)
    color_print("info", "接下来会列出各个配置列表, 请按需求修改 ", false); count_down(3, false)
    
    if is_main == "true" then
        configure_shard(shard_path, true, true)
    else
        configure_shard(shard_path, false, true)
    end

    clear()
    color_print("success", "世界配置完成！", true)
    print_divider("-", 36)
end

function convert_from_other(input_file_path, output_file_path)
    os.exit(1)
end

if arg[2] == 'new' then
    -- 命令行指令例子:  lua ./configure_world.lua /home/tide/DSTServerManager new $cluster_path true true Main Cave
    generate_new(arg[3], arg[4], arg[5], arg[6], arg[7])
elseif arg[2] == 'update' then
    -- 命令行指令例子:  lua ./configure_world.lua /home/tide/DSTServerManager update $shard_path true
    change_options(arg[3], arg[4])
elseif arg[2] == 'convert' then
    color_print("error", "导入功能还没写emmm", true)
    os.exit(1)
end

