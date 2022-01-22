#!/usr/bin/env lua

function color_print(color, str, need_new_line, no_prefix)
    local _esc = "\27"              -- 更改输出颜色用的前缀
    local _reset = _esc.."[0m"      -- 重置所有颜色，字体设定
    local _prefix = ""
    local _color = ""

    if color == "info" then
        _color = 33
        _prefix = "[INFO] "
    elseif color == "warn" then
        _color = 190
        _prefix = "[WARN] "
    elseif color == "success" then
        _color = 46
        _prefix = "[OK] "
    elseif color == "error" then
        _color = 196
        _prefix = "[ERROR] "
    elseif color == "tip" then
        _color = 215
        _prefix = "[TIP] "
    elseif color == "debug" then
        _color = 141
        _prefix = "[DEBUG] "
    else
        _color = color
    end

    if no_prefix then _prefix = "" end
    local _output = string.format("%s[38;5;%sm%s%s", _esc, _color, _prefix..str, _reset)
    if need_new_line then
        print(_output)
    else
        io.write(_output)
    end
end

function clear()
    os.execute("clear")
end

function sleep(seconds)
    os.execute("sleep " .. tonumber(seconds))
end

function sleepms(seconds) 
    local _sec = tonumber(os.clock() + seconds); 
    while (os.clock() < _sec) do 
    end 
end

function count_down(seconds, use_dot)
    if use_dot then
        for i=seconds, 1, -1 do
            color_print(102, ".", false)
            io.flush()
            sleep(1)
        end
        print()
    else
        for i=seconds, 1, -1 do
            color_print(102, i.." ", false)
            io.flush()
            sleep(1)
        end
        color_print(102, "0", true)
    end
end

function exec_linux_command_get_output(command)
    local _handle = io.popen(command,"r")
    local _content = _handle:read("*all")
    _handle:close()
    return string.sub(_content, 1, #_content-1)
end

function print_divider(char, color)
    local _cols = exec_linux_command_get_output("tput cols")
    local _line = ""
    for i=1, _cols do
        _line = _line .. char
    end
    color_print(color, _line, true)
end

function yes_or_no(color, message)
    while true do
        color_print(color, message, true)
        print("1) yes")
        print("2) no")
        io.write("请输入选项数字> ")
        local _answer = io.read()

        if _answer == "1" then
            return true
        elseif _answer == "2" then
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
        local _selected = tonumber(io.read())

        if _selected ~= nil and 1 <= _selected and _selected <= #array then
            return array[_selected]
        else
            color_print("error", "请输入正确的数字！", true)
        end
    end
    print()
end

-- Retuen: indexes
function multi_select(array, color, message)
    local _result = {}
    color_print(color, message, true)
    while true do
        for i, v in ipairs(array) do
            print(string.format("%d) %s", i, tostring(v)))
        end
        io.write("(多选请用空格隔开)请输入选项数字> ")
        for _, input in ipairs(split(io.read(), " ")) do
            local _num = tonumber(input)
            if _num ~= nil and 1 <= _num and _num <= #array then
                _result[#_result+1] = _num
            else
                color_print("warn", "请输入正确数字。错误输入将被无视: "..input, true)
            end
        end
        if #_result > 0 then break end
    end
    color_print("info", "你选择的: "..array2string(_result), false)
    count_down(3, true)
    return _result
end

function array2string(array)
    local _str = ""
    for _, _item in ipairs(array) do
        _str = _str .. _item .. " "
    end
    return _str
end

function indexof(array, target)
    for i, _elem in ipairs(array) do
        if _elem == target then
            return i
        end
    end
    return -1
end

function get_keys(table)
    local _array = {}
    for k, _ in pairs(table) do
        _array[#_array+1] = k
    end
    return _array
end

function value_en2zh(value_types, target_type, value_en)
    local _index = indexof(value_types[target_type]["en"], value_en)
    return value_types[target_type]["zh"][_index]
end

function value_zh2en(value_types, target_type, value_zh)
    local _index = indexof(value_types[target_type]["zh"], value_zh)
    return value_types[target_type]["en"][_index]
end

function file_exist(path)
    local _command = "if [ -e "..path.." ]; then echo 'yes'; else echo 'no'; fi"
    local _result = exec_linux_command_get_output(_command)
    if _result == "yes" then
        return true
    else
        return false
    end
end

function copy_file(source_file_path, destination_path)
    os.execute("cp " .. source_file_path .. " " .. destination_path)
end

function readline(empty_ok, color, message)
    local _line = ""
    while true do
        color_print(color, message, true)
        io.write("> ")
        _line = io.read()
        if empty_ok == false and #_line == 0 then
            color_print("error", "输入不能为空!", true)
        else
            break
        end
    end
    return _line
end

function get_positive_number()
    local _num
    while true do
        local _input = readline(false, "info", "请输入大于0的数字")
        _num = tonumber(_input)
        if _num == nil then
            color_print("error", "请输入正确的数字!", true)
        elseif _num <= 0 then
            color_print("error", "请输入大于0的数字!", true)
        else
            break
        end
    end
    return _num
end

function get_port()
    local _num
    while true do
        local _input = readline(false, "info", "请输入2000~65535之间的数字")
        _num = tonumber(_input)
        if _num == nil then
            color_print("error", "请输入正确的数字!", true)
        elseif _num < 2000 or 65535 < _num then
            color_print("error", "端口指定范围为 2000~65535 !", true)
        else
            break
        end
    end
    return _num
end

function split(input, char)
    if char == nil then char = "%s" end
    local _array={}
    for str in string.gmatch(input, "([^"..char.."]+)") do
        table.insert(_array, str)
    end
    return _array
end

function get_ipv4_address()
    while true do
        local _input = readline(false, "info", "请输入IPv4地址")
        local _list = split(_input, ".")
        local _count = 0
        local _flag = true

        for _, v in ipairs(_list) do
            _count = _count + 1
            local _num = tonumber(v)
            if _num == nil or _num < 0 or 255 < _num then
                _flag = false
            end
        end
        if _count ~= 4 then _flag = false end

        if _flag then
            return _input
        else
            color_print("error", "错误的IPv4地址: ".._input, true)
            color_print("tip", "IPv4格式为: 111.111.111.111", true)
            color_print("tip", "111的部分可以是0~255的数字", true)
        end
    end
end

function tablelength(table)
    local _count = 0
    for _ in pairs(table) do _count = _count + 1 end
    return _count
end

-- Return: 保存在.cacha/modinfo里面的mod的ID数组
function get_installed_mods_id(cache_dir)
    local _id_list_string = exec_linux_command_get_output("ls "..cache_dir.." | awk -F. '{print $1}'")
    if #_id_list_string == 0 then return {} end
    return split(_id_list_string, "\n")
end

-- Return: 保存在modoverrides.lua里面的mod的ID数组
function get_added_mods_id(configuration, installed_mods)
    local added_mods = {}
    for key,_ in pairs(configuration) do
        local id = split(key, "-")[2]
        added_mods[#added_mods+1] = installed_mods[id]
    end
    return added_mods
end

function generate_installed_mods_table(cache_dir)
    local _table = {}
    local _id_list = get_installed_mods_id(cache_dir)
    _table["id_array"] = _id_list
    _table["name_array"] = {}

    for index, id in ipairs(_id_list) do
        dofile(modinfo_cache_dir.."/"..id..".lua")
        _table["name_array"][index] = name
        _table[id] = name
        _table[name] = id
    end

    reset_dofile_modinfo()
    return _table
end

function save_configuration_to_file(configuration, file_path)
    os.execute("echo '' > "..file_path)
    os.execute("gsed -i -e '$i return {' "..file_path)

    for key, setting_table in pairs(configuration) do
        os.execute("gsed -i -e '$i \\    [\""..key.."\"]={' "..file_path)
        local enabled = setting_table["enabled"]
        os.execute("gsed -i -e '$i \\        enabled="..tostring(enabled)..",' "..file_path)
        os.execute("gsed -i -e '$i \\        configuration_options={' "..file_path)
        local options = setting_table["configuration_options"]
        for k, v in pairs(options) do
            local _value = v
            if type(_value) == "string" then _value = "\"".._value.."\"" end
            os.execute("gsed -i -e '$i \\            [\""..k.."\"]="..tostring(_value)..",' "..file_path)
        end
        os.execute("gsed -i -e '$i \\        }' "..file_path)
        os.execute("gsed -i -e '$i \\    },' "..file_path)
    end

    os.execute("gsed -i -e '$i }' "..file_path)
end

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

function is_mod_configurable(mod_id)
    dofile(modinfo_cache_dir.."/"..mod_id..".lua")
    if configuration_options ~= nil then
        return true
    end
    reset_dofile_modinfo()
    return false
end
