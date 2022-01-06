#!/usr/bin/env lua
-- arg[1]: $repo_root_dir  -->  /home/tide/DSTServerManager
--package.path = package.path..';'..arg[1]..'/scripts/lua/?.lua;'..arg[1]..'/templates/?.lua;'
--dofile("/home/tide/DSTServerManager/scripts/utils.lua")
--dofile("/home/tide/DSTServerManager/scripts/model/value_types.lua")
--dofile("/home/tide/DSTServerManager/scripts/model/main_table.lua")
--dofile("/home/tide/DSTServerManager/scripts/model/cave_table.lua")
require("value_types")
require("main_table")
require("cave_table")

function change_value(table)
    local target = select_one(get_keys(table))
    local value_type = table[target]["type"]
    local value_option = value_types[value_type]["zh"]
    local new_value = select_one(value_option)

    table[target]["default"] = value_zh2en(value_type, new_value)
end

function display_options(array, table, prefix, is_generation)
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
                change_value(table[key])
            else
                break
            end

            print()
        end
    end
end

function configure_world(is_main, is_generation)
    local prefix = ""
    local array = {}
    local table = {}
    if is_main then
        if is_generation then
            array = main_generations_array; table = main_generations_table; prefix = "地上世界 - 生成设置 - ";
        else
            array = main_settings_array; table = main_settings_table; prefix = "地上世界 - 选项设置 - ";
        end
    else
        if is_generation then
            array = cave_generations_array; table = cave_generations_table; prefix = "地底世界 - 生成设置 - ";
        else
            array = cave_settings_array; table = cave_settings_table; prefix = "地底世界 - 选项设置 - ";
        end
    end
    display_options(array, table, prefix, is_generation)
end

function start_configure(has_main, has_cave)
    clear()
    print_divider("-", 36)
    color_print("info", "开始配置世界！", true)
    color_print("info", "接下来会列出各个配置列表, 请按需求修改 ", false); count_down(3, false)
    
    local result = {}

    if has_main then
        configure_world(true, true); result["maingenerations"] = main_generations_table;
        configure_world(true, false); result["mainsettings"] = main_settings_table;
    end
    if has_cave then
        configure_world(false, true); result["cavegenerations"] = cave_generations_table;
        configure_world(false, false); result["cavesettings"] = cave_settings_table;
    end

    clear()
    color_print("success", "世界配置完成！", true)
    print_divider("-", 36)

    return result
end

-- main(true, true)

function confirm_settings(table, temp_path, output_path)
    local template_file = dofile(temp_path)
    local template = template_file["overrides"]

    for tmp01, value in pairs(table) do
        for tmp02, v in pairs(value) do
            local old_value = template[v["en"]]
            if old_value ~= nil and old_value ~= v["default"] then
                --print(string.format("%s:\t\t\t%s ---> %s", v["en"], old_value, v["default"]))
                local command = "sed -i -e \"s/"..v["en"].."=\\\""..old_value.."\\\"/"..v["en"].."=\\\""..v["default"].."\\\"/g\" "..output_path
                --print(command)
                os.execute(command)
            end
        end
    end
end

function config_panal()
    local template_file_path = arg[1].."/templates/server_main.lua"
    local output_file_path = "./worldgenoverride.lua"
    os.execute("cp " .. template_file_path .. " " .. output_file_path)

    result = start_configure(true, false)
    if result["maingenerations"] ~= nil then
        confirm_settings(result["maingenerations"], template_file_path, output_file_path)
    end
    if result["mainsettings"] ~= nil then
        confirm_settings(result["mainsettings"], template_file_path, output_file_path)
    end
end
