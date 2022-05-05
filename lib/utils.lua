----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------
-- 输出用的函数

function color_print(color_str, str, need_new_line, no_prefix)
    local esc = "\27"              -- 更改输出颜色用的前缀
    local reset = esc.."[0m"       -- 重置所有颜色，字体设定
    local prefix = ""
    local color = ""

    if color_str == "info" then
        color = 33
        prefix = "[INFO] "
    elseif color_str == "warn" then
        color = 190
        prefix = "[WARN] "
    elseif color_str == "success" then
        color = 46
        prefix = "[OK] "
    elseif color_str == "error" then
        color = 196
        prefix = "[ERROR] "
    elseif color_str == "tip" then
        color = 215
        prefix = "[TIP] "
    elseif color_str == "debug" then
        color = 141
        prefix = "[DEBUG] "
    else
        color = color_str
    end

    if no_prefix then prefix = "" end
    local output = string.format("%s[38;5;%sm%s%s", esc, color, prefix..str, reset)
    if need_new_line == true then
        print(output)
    else
        io.write(output)
    end
end

function print_divider(char, color)
    local cols = exec_linux_command_get_output("tput cols")
    local line = ""
    for i=1, cols do
        line = line .. char
    end
    color_print(color, line, true)
end

function count_down(seconds, use_number)
    if use_number then
        for i=seconds, 1, -1 do
            color_print(102, i.." ", false)
            io.flush()
            sleep(1)
        end
        color_print(102, "0", true)
    else
        for i=seconds, 1, -1 do
            color_print(102, ".", false)
            io.flush()
            sleep(1)
        end
        print()
    end
end

----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------
-- 互动用的函数

function confirm(color, message)
    while true do
        color_print(color, message, true)
        print("1) yes")
        print("2) no")
        io.write("请输入选项数字> ")
        local answer = io.read()

        if answer == "1" then
            return true
        elseif answer == "2" then
            return false
        else
            color_print("error", "请输入正确的数字！", true)
        end
    end
    print()
end

function select_one(array, color, message)
    color_print(color, message, true)
    while true do
        for i, v in ipairs(array) do
            print(string.format("%d) %s", i, tostring(v)))
        end
        io.write("请输入选项数字> ")
        local selected = tonumber(io.read())

        if selected ~= nil and 1 <= selected and selected <= #array then
            return array[selected]
        else
            color_print("error", "请输入正确的数字！", true)
        end
    end
    print()
end

-- Retuen: indexes
function multi_select(array, color, message)
    local result = {}
    color_print(color, message, true)
    while true do
        for i, v in ipairs(array) do
            print(string.format("%d) %s", i, tostring(v)))
        end
        io.write("(多选请用空格隔开)请输入选项数字> ")
        for _, input in ipairs(split(io.read(), " ")) do
            local num = tonumber(input)
            if num ~= nil and 1 <= num and num <= #array then
                result[#result+1] = num
            else
                color_print("warn", "请输入正确数字。错误输入将被无视: "..input, true)
            end
        end
        if #result > 0 then break end
    end
    color_print("info", "你选择的: "..array2string(result), false)
    count_down(3, true)
    return result
end

function readline(empty_ok, color, message)
    local line = ""
    while true do
        color_print(color, message, true)
        io.write("> ")
        line = io.read()
        if empty_ok == false and #line == 0 then
            color_print("error", "输入不能为空!", true)
        else
            break
        end
    end
    return line
end

function get_positive_number()
    local num
    while true do
        local input = readline(false, "info", "请输入大于0的数字")
        num = tonumber(input)
        if num == nil then
            color_print("error", "请输入正确的数字!", true)
        elseif num <= 0 then
            color_print("error", "请输入大于0的数字!", true)
        else
            break
        end
    end
    return num
end

function get_port()
    local num
    while true do
        local input = readline(false, "info", "请输入2000~65535之间的数字")
        num = tonumber(input)
        if num == nil then
            color_print("error", "请输入正确的数字!", true)
        elseif num < 2000 or 65535 < num then
            color_print("error", "端口指定范围为 2000~65535 !", true)
        else
            break
        end
    end
    return num
end

function get_ipv4_address()
    while true do
        local input = readline(false, "info", "请输入IPv4地址")
        local list = split(input, ".")
        local count = 0
        local flag = true

        for _, v in ipairs(list) do
            count = count + 1
            local num = tonumber(v)
            if num == nil or num < 0 or 255 < num then
                flag = false
            end
        end
        if count ~= 4 then flag = false end

        if flag then
            return input
        else
            color_print("error", "错误的IPv4地址: "..input, true)
            color_print("tip", "IPv4格式为: 111.111.111.111", true)
            color_print("tip", "111的部分可以是0~255的数字", true)
        end
    end
end

----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------
-- 执行Linux命令的函数

function clear()
    os.execute("clear")
end

function sleep(seconds)
    os.execute("sleep " .. tonumber(seconds))
end

function sleepms(seconds)
    local sec = tonumber(os.clock() + seconds);
    while (os.clock() < sec) do
    end
end

function exec_linux_command_get_output(command)
    local handle = io.popen(command,"r")
    local content = handle:read("*all")
    handle:close()
    return string.sub(content, 1, #content-1)
end

function file_exist(path)
    local command = "if [ -e "..path.." ]; then echo 'yes'; else echo 'no'; fi"
    local result = exec_linux_command_get_output(command)
    if result == "yes" then
        return true
    else
        return false
    end
end

function copy_file(source_file_path, destination_path, is_dir)
    if is_dir == true then
        os.execute("cp -r " .. source_file_path .. " " .. destination_path)
    else
        os.execute("cp " .. source_file_path .. " " .. destination_path)
    end
end

----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------
-- 扩展Lua基础功能的函数

function array2string(array)
    local str = ""
    for _, item in ipairs(array) do
        str = str .. item .. " "
    end
    return str
end

function indexof(array, target)
    for i, elem in ipairs(array) do
        if elem == target then
            return i
        end
    end
    return -1
end

function get_keys(table)
    local array = {}
    for k, _ in pairs(table) do
        array[#array+1] = k
    end
    return array
end

function split(input, char)
    if char == nil then char = "%s" end
    local array={}
    for str in string.gmatch(input, "([^"..char.."]+)") do
        table.insert(array, str)
    end
    return array
end

function tablelength(table)
    local count = 0
    for _ in pairs(table) do count = count + 1 end
    return count
end

----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------

function translate_2zh(value_types, target_type, value_en)
    local index = indexof(value_types[target_type]["key"], value_en)
    return value_types[target_type]["zh"][index]
end

function translate_2key(value_types, target_type, value_zh)
    local index = indexof(value_types[target_type]["zh"], value_zh)
    return value_types[target_type]["key"][index]
end

function get_all_installed_modinfo_path(repo_root, v1dir, v2dir)
    local result = exec_linux_command_get_output(repo_root.."/bin/utils/get_all_modinfo_path "..v1dir.." "..v2dir)
    local array = split(result, "\n")
    return array
end

function get_modinfo_path(repo_root, v1dir, v2dir, id)
    local result = exec_linux_command_get_output(repo_root.."/bin/utils/get_all_modinfo_path "..v1dir.." "..v2dir.." | grep -s "..id)
    return result
end

---------------------------------------
-- 作用: 清除读取modinfo.lua文件后残留的变量
---------------------------------------
function reset_dofile_modinfo()
    if name ~= nil then name = nil end
    if description ~= nil then description = nil end
    if author ~= nil then author = nil end
    if version ~= nil then version = nil end
    if forumthread ~= nil then forumthread = nil end
    if api_version ~= nil then api_version = nil end

    if client_only_mod ~= nil then client_only_mod = nil end
    if all_clients_require_mod ~= nil then all_clients_require_mod = nil end
    if configuration_options ~= nil then configuration_options = nil end
    if server_filter_tags ~= nil then server_filter_tags = nil end

    if dst_compatible ~= nil then dst_compatible = nil end
    if dont_starve_compatible ~= nil then dont_starve_compatible = nil end
    if reign_of_giants_compatible ~= nil then reign_of_giants_compatible = nil end
    if shipwrecked_compatible ~= nil then shipwrecked_compatible = nil end
    if hamlet_compatible ~= nil then hamlet_compatible = nil end
    if porkland_compatible ~= nil then porkland_compatible = nil end
end

function get_info_from_modinfo(modinfo_path, property)
    local command = property.."=$(lua -e \"locale = \\\"zh\\\"; folder_name = \\\"\\\"; dofile(\\\""..modinfo_path.."\\\"); print("..property..")\"); echo $"..property
    return exec_linux_command_get_output(command)
end

function generate_installed_mods_table(repo_root, v1dir, v2dir)
    reset_dofile_modinfo()
    local result = exec_linux_command_get_output(repo_root.."/bin/utils/get_all_modinfo_path "..v1dir.." "..v2dir)
    local all_modinfo = split(result, "\n")

    local dic = {}
    dic["id_array"] = {}
    dic["name_array"] = {}
    dic["path_array"] = {}
    -- mods_dic = {
    --     ["id_array"] = {},
    --     ["name_array"] = {},
    --     ["path_array"] = {
    --         ["111"] = "/.../.../.../modinfo.lua"
    --     },
    --     ["1111"] = "名前1",
    --     ["2222"] = "名前2",
    --     ["3333"] = "名前3",
    --     ...
    -- }
    
    for index, path in ipairs(all_modinfo) do
        local name = get_info_from_modinfo(path, "name")
        local id = exec_linux_command_get_output("echo "..path.." | awk -F/ '{print $(NF-1)}'")
        if string.find(id, "workshop") then
            id = string.sub(id, 9)
        end
        table.insert(dic["id_array"], id)
        table.insert(dic["name_array"], name)
        dic["path_array"][id] = path
        dic[id] = name
        dic[name] = id
    end
    
    return dic
end
