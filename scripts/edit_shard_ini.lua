#!/usr/bin/env lua
-- arg[1]: $repo_root_dir       --> ~/DSTServerManager
-- arg[2]: shard dir path       --> ~/Klei/worlds/c01/Cave

package.path = package.path..';'..arg[1]..'/scripts/?.lua;'..arg[1]..'/scripts/model/?.lua;'
require("utils")
require("value_types_ini")
require("table__shard")

----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------

-- Return: new model
function update_model_from_file(old_model, new_file_path)
    local option_array = old_model["array"]
    for i, option_name in pairs(option_array) do
        local en = old_model[option_name]["en"]
        local old_value = old_model[option_name]["value"]
        local new_value = exec_linux_command_get_output("cat "..new_file_path.." | grep ^"..en.." | awk -F ' = ' '{print $2}'")
        if new_value ~= nil and new_value ~= old_value then
            old_model[option_name]["value"] = new_value
        end
    end
    return old_model
end

function apply_changes_to_file(table, file_path)
    local option_array = table["array"]
    for i, option_name in pairs(option_array) do
        local en = table[option_name]["en"]
        local new_value = table[option_name]["value"]
        local old_value = exec_linux_command_get_output("cat "..file_path.." | grep ^"..en.." | awk -F ' = ' '{print $2}'")
        if old_value ~= nil and old_value ~= new_value then
            local command = "sed -i -e \"s/"..en.." = "..old_value.."/"..en.." = "..new_value.."/g\" "..file_path
            os.execute(command)
        end
    end
end

function show_settings(table, show_description)
    local option_array = table["array"]
    for i, option_name in pairs(option_array) do
        local value = table[option_name]["value"]
        local value_type = table[option_name]["type"]
        --sleepms(0.1)
        print(string.format("%s = %s", option_name, value))
        if show_description then
            local description = table[option_name]["description"]
            color_print(242, "    "..description, true)
        end
    end
    print()
end

function configure_model(table)
    local show_description = yes_or_no("info", "是否显示各个设置的说明？")
    while true do
        clear()
        print_divider("-", 36)
        color_print("info", "以下是世界设置, 请根据自身情况修改", true)
        print()

        show_settings(table, show_description)

        local answer = yes_or_no("info", "是否有需要修改的？")
        if answer == false then break end

        local option_array = table["array"]
        local target = select_one(option_array, "info", "请选一个选项")
        local value_type = table[target]["type"]
        local new_value
        if value_type == "string" then
            new_value = readline(false, "info", "请输入新的"..target)
        elseif value_type == "port" then
            new_value = get_port()
        else
            local value_options = ini_value_types[value_type]["zh"]
            local new_value_zh = select_one(value_options, "info", "修改"..target)
            new_value = value_zh2en(ini_value_types, value_type, new_value_zh)
        end
        color_print("info", target..": "..table[target]["value"].." --> "..new_value, true)
        table[target]["value"] = new_value
        sleep(1)
    end
end

----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------
-- 新建或者更改, 流程都是: 读取model, 更新model, 展示model, 保存model

clear()
print_divider("-", 36)
color_print("info", "即将开始配置server.ini...", true)

-- 读取/更新model
local file_path = arg[2].."/server.ini"
local model = update_model_from_file(shard_table, file_path)
configure_model(model)
apply_changes_to_file(model, file_path)

clear()
color_print("success", "server.ini配置完成！", true)
print_divider("-", 36)
