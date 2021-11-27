source ~/DSTServerManager/utils/output.sh

# Parameters:
#   $1: a list of packages
function check_dependencies() {
    color_print info '以上软件是否已安装？没有安装的话请联系该服务器的管理员...'
    read -p '向管理员确认已经安装之后, 输入ok并回车> ' answer
    case $answer in
    'ok'|'OK'|'Ok')
        return 0
        ;;
    *)
    color_print error '无权限下载安装必须软件，终止运行脚本。请联系服务器管理员解决。'
        exit 1
        ;;
    esac
}

# Parameters:
#   $1: OS
#   $2: architecture(32 or 64)
function install_dependencies() {
    if [[ $(whoami) != 'root' ]] && ! groups $(whoami) | grep sudo > /dev/null 2>&1; then
        not_root=0
        color_print error '当前用户没有管理员权限, 请确认以下软件已经安装'
    else
        not_root=1
    fi

    if [[ $1 == 'Ubuntu' ]]; then
        if [[ $2 == 64 ]]; then
            # 64bit Ubuntu/Debian
            #sudo dpkg --add-architecture i386
            #sudo apt install -y lib32gcc1 lib32stdc++6 libcurl4-gnutls-dev:i386   #? lua5.2 openssl libssl-dev curl
            #sudo apt install -y libsdl2-2.0-0:i386         # To fix a sdl warning during dst installation
            requires=(lib32gcc1 lib32stdc++6 libcurl4-gnutls-dev:i386 libsdl2-2.0-0:i386 tmux wget git)
            if [[ $not_root == 0 ]]; then
                echo ${requires[@]}
                check_dependencies "$requires"
                return 0
            fi
        else
            # 32bit Ubuntu/Debian
            #sudo apt install -y libgcc1 libstdc++6 libcurl4-gnutls-dev   #? lua5.2 openssl libssl-dev curl
            requires=(libgcc1 libstdc++6 libcurl4-gnutls-dev tmux wget git)
            if [[ $not_root == 0 ]]; then
                echo ${requires[@]}
                check_dependencies $requires
                return 0
            fi
        fi
        
        color_print info '需要下载或更新的软件: '
        echo ${requires[@]}
        color_print info '即将以管理员权限下载更新软件，请输入当前用户的密码 ' -n; count_down 3
        if [[ $2 == 64 ]]; then sudo dpkg --add-architecture i386; fi
        sudo apt update && sudo apt upgrade -y
        for package in $requires; do
            sudo apt install -y $package
        done

        color_print info '依赖包下载安装完成! ' -n; count_down 3
        return 0
    fi

    if [[ $1 == 'CentOS' ]]; then
        if [[ $2 == 64 ]]; then
            # 64bit CentOS/Redhat
            #sudo yum install -y glibc.i686 libstdc++.i686   #? libstdc++ libcurl.i686 lua5.2 openssl openssl-devel curl
            requires=(glibc.i686 libstdc++.i686 tmux wget git)
            if [[ $not_root == 0 ]]; then
                echo ${requires[@]}
                check_dependencies $requires
                return 0
            fi
        else
            # 32bit CentOS/Redhat
            #sudo yum install -y glibc libstdc++ glibc.i686 libcurl.so.4 libstdc++.so.6   #? libcurl lua5.2 openssl openssl-devel curl
            requires=(glibc libstdc++ glibc.i686 libcurl.so.4 libstdc++.so.6 tmux wget git)
            if [[ $not_root == 0 ]]; then
                echo ${requires[@]}
                check_dependencies $requires
                return 0
            fi
        fi

        color_print info '需要下载或更新的软件: '
        echo ${requires[@]}
        color_print info '即将以管理员权限下载更新软件，请输入当前用户的密码 ' -n; count_down 3
        sudo yum update && sudo yum upgrade -y
        for package in $requires; do
            sudo apt yum -y $package
        done

        color_print info '依赖包下载安装完成!'
        color_print info '报错 libcurl.so.4 (RedHat/CentOS) 的话输入以下命令:'
        color_print info 'cd /usr/lib && ln -s libcurl.so.4 libcurl-gnutls.so.4'
        count_down 3
        return 0
    fi

    color_print error "本脚本暂不支持当前系统版本"
    exit 1
}

# Parameters:
#   $1: a path to the dst server directory
function install_steam_and_dst() {
    # https://developer.valvesoftware.com/wiki/SteamCMD#Linux
    if [[ ! -e ~/Steam ]]; then mkdir ~/Steam; fi
    cd ~/Steam
    if [[ ! -e steamcmd.sh ]]; then
        color_print info '未发现steamcmd.sh脚本，开始下载... ' -n; count_down 3
        wget "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz"
        tar -xvzf steamcmd_linux.tar.gz
        rm -f steamcmd_linux.tar.gz
        color_print info 'steamcmd.sh脚本下载完成！'
    fi
    if [[ ! -e $1 ]]; then
        color_print info "路径$1 未找到饥荒服务端，即将开始下载..."
        color_print info '根据网络状况，下载可能会很耗时间，下载完成为止请勿息屏 ' -n; count_down 3
        mkdir -p $1
        ./steamcmd.sh +login anonymous +force_install_dir $1 +app_update 343050 validate +quit
        color_print info '饥荒服务端下载安装完成! ' -n; count_down 3
    fi
    cd ~
}

# Parameters:
#   $1: OS
#   $2: architecture(32 or 64)
#   $3: a path to the dst server directory
function check_requirements() {
    if [[ -e $3/.first_run ]]; then return 0; fi
    
    install_dependencies $1 $2
    install_steam_and_dst $3
    touch $3/.first_run
}
