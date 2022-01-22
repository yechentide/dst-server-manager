#!/usr/bin/env lua
-- arg[1]: $repo_root_dir       --> ~/DSTServerManager
-- arg[2]: action               --> add / update

package.path = package.path..';'..arg[1]..'/scripts/?.lua;' --..arg[1]..'/scripts/model/?.lua;'
require("utils")

-- 使用lua配置前, 先通过shellscript来把modoverride.lua文件复制到 $repo_root_dir/.cache
-- 配置完毕以后, 同步到存档里的各个世界
modinfo_cache_dir = arg[1].."/.cache/modinfo"
target_file_path = arg[1].."/.cache/modoverrides.lua"

----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------

function show_settings(mod_id, current_mod_settings, show_description)
    dofile(modinfo_cache_dir.."/"..mod_id..".lua")
    print("是否启用 = "..tostring(current_mod_settings["enabled"]))
    if show_description then
        color_print(242, "    调成false的话就可以禁用该mod", true)
    end
    for _, option in ipairs(configuration_options) do
        local option_name = option["name"]
        local option_value = current_mod_settings["configuration_options"][option_name]
        print(option_name.." = "..tostring(option_value))
        if show_description then
            if option["label"] ~= nil then color_print(242, "    "..option["label"], true) end
            if option["hover"] ~= nil then color_print(242, "    "..option["hover"], true) end
        end
    end
    print()
    reset_dofile_modinfo()
end

function get_mod_setting_options(mod_id)
    dofile(modinfo_cache_dir.."/"..mod_id..".lua")
    local options_array = {"是否启用"}
    for _, option in ipairs(configuration_options) do
        options_array[#options_array+1] = option["name"]
    end
    reset_dofile_modinfo()
    return options_array
end

function get_new_setting(mod_id, option, option_index, show_description)
    print()
    color_print("info", "---------- ----------", true, true)
    color_print("info", "选项 "..option.." 可以选择的值为:", true)

    local new_value

    if option == "是否启用" then
        print("false")
        print("true")
        new_value = select_one({false, true}, "info", "请选择一个值")
    else
        dofile(modinfo_cache_dir.."/"..mod_id..".lua")
        local option_name = configuration_options[option_index]["name"]
        local options = configuration_options[option_index]["options"]
        local values_list = {}
        for _, option in ipairs(options) do
            values_list[#values_list+1] = option["data"]
            print(tostring(option["data"]))
            if show_description then
                if option["description"] ~= nil then color_print(242, "    "..option["description"], true) end
                if option["hover"] ~= nil then color_print(242, "    "..option["hover"], true) end
            end
        end
        new_value = select_one(values_list, "info", "请选择一个值")
        reset_dofile_modinfo()
    end

    print("新的值为: "..tostring(new_value))
    sleep(1)
    return new_value
end

function configure_mod(mod_id, mod_name, configuration)
    local show_description = yes_or_no("info", "是否显示各个设置的说明？")
    while true do
        clear()
        print_divider("-", 36)
        color_print("tip", "以下是模组 "..mod_name.." 的设置, 请根据自身情况修改", true)
        color_print("info", "配置一览", true)
        print()

        local current_mod_settings = configuration["workshop-"..mod_id]
        show_settings(mod_id, current_mod_settings, show_description)

        local answer = yes_or_no("info", "是否有需要修改的？")
        if answer == false then break end

        local options_array = get_mod_setting_options(mod_id)
        local target_option = select_one(options_array, "info", "请选一个选项")
        local index = indexof(options_array, target_option) - 1
        local new_value = get_new_setting(mod_id, target_option, index, show_description)
        if target_option == "是否启用" then
            current_mod_settings["enabled"] = new_value
        else
            current_mod_settings["configuration_options"][target_option] = new_value
        end
    end
end

----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------

function add_new_mods(target_file)
    -- 从 .cache/modinfo 获得列表（ID + Name）
    local _installed_mods = generate_installed_mods_table(modinfo_cache_dir)

    -- 用户选择mod
    local _selected_mods = multi_select(_installed_mods["name_array"], "info", "(多选用空格隔开)请选择要添加的Mod")

    -- 读取/更新model
    local configuration = dofile(target_file)
    for _, index in ipairs(_selected_mods) do
        local _id = _installed_mods["id_array"][index]
        local _name = _installed_mods["name_array"][index]
        if configuration["workshop-".._id] ~= nil then
            color_print("warn", "模组 ".._name.." 已存在, 无需再次添加!", true)
        else
            color_print("success", "添加模组 ".._name, true)
            dofile(modinfo_cache_dir.."/".._id..".lua")
            -- 添加mod设置到model
            configuration["workshop-".._id] = {}
            configuration["workshop-".._id]["enabled"] = true
            configuration["workshop-".._id]["configuration_options"] = {}
            for _, option in ipairs(configuration_options) do
                local _key = option["name"]
                local _value = option["default"]
                configuration["workshop-".._id]["configuration_options"][_key] = _value
            end
            -- 保存model
            save_configuration_to_file(configuration, target_file)
            reset_dofile_modinfo()
        end
    end
end

function configure_modoverride(target_file)
    local configuration = dofile(target_file)
    local installed_mods = generate_installed_mods_table(modinfo_cache_dir)
    local added_mods = get_added_mods_id(configuration, installed_mods)

    while true do
        clear()
        print_divider("-", 36)
        color_print("tip", "以下是当前存档里的Mod:", true)
        print()

        local mod_name = select_one(added_mods, "info", "请选择要配置的Mod")
        local mod_id = installed_mods[mod_name]

        if is_mod_configurable(mod_id) then
            color_print("info", "即将开始配置模组 "..mod_name, true)
            configure_mod(mod_id, mod_name, configuration)
        else
            color_print("warn", "模组 "..mod_name.." 没有可设置的选项!", true)
        end

        local answer = yes_or_no("info", "是否继续修改其他Mod？")
        if answer == false then break end
    end
    save_configuration_to_file(configuration, target_file)
end

configure_modoverride(target_file_path)

if arg[2] == 'add' then
    add_new_mods(target_file_path)
elseif arg[2] == 'update' then
    configure_modoverride(target_file_path)
end
