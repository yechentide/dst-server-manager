#!/usr/bin/env lua

function color_print(color, str, need_new_line)
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
    local sec = tonumber(os.clock() + seconds); 
    while (os.clock() < sec) do 
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
    local handle = io.popen(command,"r")
    local content = handle:read("*all")
    handle:close()
    return string.sub(content, 1, #content-1)
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
    while true do
        color_print(color, message, true)
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

function array2string(array)
    local str = ""
    for i, option in ipairs(array) do
        str = str .. option .. " "
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
    for k, v in pairs(table) do
        array[#array+1] = k
    end
    return array
end

function value_en2zh(value_types, target_type, value_en)
    local index = indexof(value_types[target_type]["en"], value_en)
    return value_types[target_type]["zh"][index]
end

function value_zh2en(value_types, target_type, value_zh)
    local index = indexof(value_types[target_type]["zh"], value_zh)
    return value_types[target_type]["en"][index]
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
