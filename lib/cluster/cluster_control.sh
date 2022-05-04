#######################################
# 作用: 去除worldgenoverride.lua文件里的'KLEI     1'
# 参数:
#   $1: 世界文件夹的绝对路径
#######################################
function remove_klei_from_worldgenoverride() {
    if head -n 1 $1/worldgenoverride.lua | grep -sq 'KLEI'; then
        sed -i -e 's/^KLEI     1 //g' $1/worldgenoverride.lua
    fi
}
