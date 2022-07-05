#!/usr/bin/env lua
-- arg[1]: $repo_root_dir       --> ~/DSTServerManager
-- arg[2]: action               --> add / update / delete
-- arg[3]: V1_MOD_DIR
-- arg[4]: V2_MOD_DIR

package.path = package.path..';'..arg[1]..'/lib/?.lua;'
require("utils")

-- 使用lua配置前, 先通过shellscript来把modoverride.lua文件复制到 $repo_root_dir/.cache
-- 配置完毕以后, 同步到存档里的各个世界
TARGET_FILE_PATH = arg[1].."/.cache/modoverrides.lua"
if arg[2] ~= 'delete' then
    installed_mods = generate_installed_mods_table(arg[1], arg[3], arg[4])
end
locale = "zh"
folder_name = ""

----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------

---------------------------------------
-- 作用: 从modoverrides.lua文件里, 获取ID列表
-- 参数:
--   modoverrides里的配置
-- 返回:
--   模组ID的数组
---------------------------------------
function get_added_mods_id(configuration)
    local added_mods = {}
    for key, _ in pairs(configuration) do
        local id = split(key, "-")[2]
        added_mods[#added_mods+1] = installed_mods[id]
    end
    return added_mods
end

---------------------------------------
-- 作用: 确认该模组是否可以更改设置
-- 参数:
--   模组ID
-- 返回:
--   true / false
---------------------------------------
function is_mod_configurable(mod_id)
    reset_dofile_modinfo()
    dofile(installed_mods["path_array"][mod_id])
    if configuration_options ~= nil then
        return true
    end
    return false
end

function save_configuration_to_file(configuration, file_path)
    os.execute("echo '' > "..file_path)
    os.execute("sed -i -e '$i return {' "..file_path)

    for key, setting_table in pairs(configuration) do
        os.execute("sed -i -e '$i \\    [\""..key.."\"]={' "..file_path)
        local enabled = setting_table["enabled"]
        os.execute("sed -i -e '$i \\        enabled="..tostring(enabled)..",' "..file_path)
        os.execute("sed -i -e '$i \\        configuration_options={' "..file_path)
        local options = setting_table["configuration_options"]
        for k, v in pairs(options) do
            local value = v
            if type(value) == "string" then value = "\""..value.."\"" end
            os.execute("sed -i -e '$i \\            [\""..k.."\"]="..tostring(value)..",' "..file_path)
        end
        os.execute("sed -i -e '$i \\        }' "..file_path)
        os.execute("sed -i -e '$i \\    },' "..file_path)
    end

    os.execute("sed -i -e '$i }' "..file_path)
end

function show_settings(mod_id, current_mod_settings, show_description)
    reset_dofile_modinfo()
    dofile(installed_mods["path_array"][mod_id])
    print("是否启用 = "..tostring(current_mod_settings["enabled"]))
    if show_description then
        color_print(242, "    调成false的话就可以禁用该mod", true)
    end
    for _, option in ipairs(configuration_options) do
        local option_name = option["name"]
        local option_value = current_mod_settings["configuration_options"][option_name]
        if option["label"] ~= nil then
            print(option["label"].." = "..tostring(option_value))
        else
            print(option_name.." = "..tostring(option_value))
        end
        if show_description then
            if option["hover"] ~= nil then color_print(242, "    "..option["hover"], true) end
        end
    end
    print()
end

function get_mod_setting_options(mod_id)
    reset_dofile_modinfo()
    dofile(installed_mods["path_array"][mod_id])
    local options_array = {"是否启用"}
    for _, option in ipairs(configuration_options) do
        if option["label"] ~= nil then
            options_array[#options_array+1] = option["label"]
        else
            options_array[#options_array+1] = option["name"]
        end
    end
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
        reset_dofile_modinfo()
        dofile(installed_mods["path_array"][mod_id])
        --local option_name = configuration_options[option_index]["name"]
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
    end

    print("新的值为: "..tostring(new_value))
    sleep(1)
    return new_value
end

function get_option_name_from_label(mod_id, label)
    reset_dofile_modinfo()
    dofile(installed_mods["path_array"][mod_id])
    for _, option in ipairs(configuration_options) do
        if option["label"] ~= nil and option["label"] == label then
            return option["name"]
        end
        if option["name"] == label then
            return option["name"]
        end
    end
end

function configure_mod(mod_id, mod_name, configuration)
    local show_description = confirm("info", "是否显示各个设置的说明？")
    while true do
        clear()
        print_divider("-", 36)
        color_print("tip", "以下是模组 "..mod_name.." 的设置, 请根据自身情况修改", true)
        color_print("info", "配置一览", true)
        print()

        local current_mod_settings = configuration["workshop-"..mod_id]
        show_settings(mod_id, current_mod_settings, show_description)

        local answer = confirm("info", "是否有需要修改的？")
        if answer == false then break end

        local options_array = get_mod_setting_options(mod_id)
        local target_option = select_one(options_array, "info", "请选一个选项")
        local index = indexof(options_array, target_option) - 1
        local new_value = get_new_setting(mod_id, target_option, index, show_description)
        if target_option == "是否启用" then
            current_mod_settings["enabled"] = new_value
        else
            target_option = get_option_name_from_label(mod_id, target_option)
            current_mod_settings["configuration_options"][target_option] = new_value
        end
    end
end

----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------

function add_new_mods(target_file)
    -- 用户选择mod
    local selected_mods = multi_select(installed_mods["name_array"], "info", "(多选用空格隔开)请选择要添加的Mod")

    -- 读取/更新model
    local configuration = dofile(target_file)
    for _, index in ipairs(selected_mods) do
        local id = installed_mods["id_array"][index]
        local name = installed_mods["name_array"][index]
        if configuration["workshop-"..id] ~= nil then
            color_print("warn", "模组 "..name.." 已存在, 无需再次添加!", true)
        else
            color_print("success", "添加模组 "..name, true)
            reset_dofile_modinfo()
            dofile(installed_mods["path_array"][id])
            -- 添加mod设置到model
            configuration["workshop-"..id] = {}
            configuration["workshop-"..id]["enabled"] = true
            configuration["workshop-"..id]["configuration_options"] = {}
            if configuration_options ~= nil then
                for _, option in ipairs(configuration_options) do
                    local key = option["name"]
                    local value = option["default"]
                    configuration["workshop-"..id]["configuration_options"][key] = value
                end
            end
        end
    end
    -- 保存model
    save_configuration_to_file(configuration, target_file)
end

function configure_modoverride(target_file)
    local configuration = dofile(target_file)
    local added_mods = get_added_mods_id(configuration)

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

        local answer = confirm("info", "是否继续修改其他Mod？")
        if answer == false then break end
    end
    save_configuration_to_file(configuration, target_file)
end

function delete_mods(target_file, delete_mod_ids_array)
    local configuration = dofile(target_file)
    local should_save = false
    for _, id in ipairs(delete_mod_ids_array) do
        local key = "workshop-"..id
        print("key: "..key)
        if configuration[key] ~= nil then
            configuration[key] = nil
            should_save = true
        end
    end
    if should_save then
        save_configuration_to_file(configuration, target_file)
    end
end

if arg[2] == 'add' then
    add_new_mods(TARGET_FILE_PATH)
elseif arg[2] == 'update' then
    configure_modoverride(TARGET_FILE_PATH)
elseif arg[2] == 'delete' then
    local delete_mod_ids_array = {}
    for i=3, #arg do
        print(arg[i])
        delete_mod_ids_array[#delete_mod_ids_array+1] = arg[i]
    end
    color_print("info", "即将删除"..#delete_mod_ids_array.."个mod", true)
    delete_mods(TARGET_FILE_PATH, delete_mod_ids_array)
end
