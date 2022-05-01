

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

function value_en2zh(value_types, target_type, value_en)
    local index = indexof(value_types[target_type]["en"], value_en)
    return value_types[target_type]["zh"][index]
end

function value_zh2en(value_types, target_type, value_zh)
    local index = indexof(value_types[target_type]["zh"], value_zh)
    return value_types[target_type]["en"][index]
end
