#!/usr/bin/env bash

#######################################
# 作用: 让用户输入token
# 输出: token = xxxxxxxx
# 返回:
#   token   保存在全局变量answer
#######################################
function get_token() {
    declare answer=''
    declare -r token_file="$REPO_ROOT_DIR/.cache/token.txt"
    declare token=''
    if [[ -e $token_file ]]; then
        token=$(cat "$token_file")
    fi

    while true; do
        color_print info "上次输入的token: $token"
        color_print tip '直接回车, 可以使用上次输入的token'
        color_print -np info '请输入token: '
        read -r answer
        if [[ ${#answer} == 0 ]]; then
            if [[ ${#token} == 0 ]]; then
                color_print error '你输入token了吗???'
                continue
            fi
            answer=$token
        fi
        # 格式: pds-g^KU_J9MSP3g1^xif7KC......
        if echo "$answer" | grep -sqv '^pds-g^KU'; then
            color_print error '输入的token不对'
            color_print error '服务器token是以pds-g^KU开头的'
            continue
        fi
        break
    done
    echo "token = $answer"
    echo "$answer" > "$token_file"
    echo "$answer" > "$ANSWER_PATH"
    sleep 2
}
