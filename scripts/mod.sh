# Parameters:
#   $1: mod id
# Retuen: 'yes' / 'no'
function is_dst_mod() {
    if wget -O - "https://steamcommunity.com/sharedfiles/filedetails/?id=$1" 2>&1 | grep -sq "Don't Starve Together"; then
        echo 'yes'
    else
        echo 'no'
    fi
}

# Parameters:
#   $1: name (在函数内部会更改这个参数原来位置的值), 注意传进来的是变量名(也就是不加$)
#   $2: mod id
function get_mod_name() {
    declare -n _tmp="$1"
    _tmp=$(wget -O - "https://steamcommunity.com/sharedfiles/filedetails/?id=$2" 2>&1 | grep -s workshopItemTitle | sed "s#\s\+<div class=\"workshopItemTitle\">\(.\+\?\)</div>#\1##g")
}

