#!/bin/bash
COLOR_DEFAULT="\e[0m"
COLOR_RED="\e[31m"
COLOR_GREEN="\e[32m"
COLOR_YELLOW="\e[33m"
COLOR_CYAN="\e[36m"
interrupt_handler() {
    echo -e "${COLOR_YELLOW}[WARN] Received Ctrl+C, Do you want to continue running the script? (Y/n)${COLOR_DEFAULT}"
    read -r answer
    case $answer in
        [Nn]) exit 1;;
        *) continue;;
    esac
}
trap interrupt_handler SIGINT
check_root() {
    if [[ $EUID -ne 0 ]]; then
        echo -e "${COLOR_RED}[ERROR] This command must be run as root!${COLOR_DEFAULT}"
        exit 1
    fi
}
if [ ! -n "$TERMUX_VERSION" ]; then
    check_root
fi

if [ ! -n "$HOME" ]; then
    echo -e "${COLOR_RED}[-]\$HOME variables do not exist, please set the variable \$HOME and try again.${COLOR_DEFAULT}"
    exit 1
fi

MAIN_DIR="$HOME/JiuWei"
HBI_FILE=".have_been_install" #记录所有已安装的包名（文本文件）
PACKAGES_FILE=".packages" #记录所有的包信息,方便search（文本文件）
CONFIG_FILE="config.list" #放置源URL（文本文件）
FOXINDEX_FILE=".foxindex" #放置FOXINDEX解压后产生的文件（文件夹）
CACHE_FILE=".cache" #放置从源中下载的安装包（文件夹）
BIN_FILE=".bin" #快捷命令存放（文件夹）
ST_FILE=".status" #JiuWei状态检测（文本文件）

HBI="$MAIN_DIR/$HBI_FILE"
PACKAGES="$MAIN_DIR/$PACKAGES_FILE"
CONFIG="$MAIN_DIR/$CONFIG_FILE"
CACHE="$MAIN_DIR/$CACHE_FILE"
FOXINDEX="$MAIN_DIR/$FOXINDEX_FILE"
BIN="$MAIN_DIR/$BIN_FILE"
ST="$MAIN_DIR/$ST_FILE"

if [ -f "/etc/os-release" ]; then
    if grep -qiF 'ID=alpine' /etc/os-release; then
        sys_name="alpine"
    elif grep -qiF 'ID=debian' /etc/os-release; then
        sys_name="debian"
    elif grep -qiF 'ID=ubuntu' /etc/os-release; then
        sys_name="ubuntu"
    elif grep -qiF 'ID=kali' /etc/os-release; then
        sys_name="kali"
    elif grep -qiF 'ID=arch' /etc/os-release; then
        sys_name="arch"
    elif grep -qiF 'ID=centos' /etc/os-release; then
        sys_name="centos"
    elif grep -qiF 'ID=*rhel*' /etc/os-release; then
        sys_name="redhat"
    fi
else
    if [ -n "$TERMUX_VERSION" ]; then
        sys_name="termux"
    elif command -v "sw_vers"; then
        sys_name="darwin"
    else
        echo -e "${COLOR_YELLOW}[*] Current system is not supported.${COLOR_DEFAULT}"
        exit 1
    fi
fi

update_run() {
    echo -e "${COLOR_YELLOW}[*] Update...${COLOR_DEFAULT}"
    if [ "$sys_name" = "alpine" ]; then
        local run="apk update"
    elif [ "$sys_name" = "debian" ] || [ "$sys_name" = "ubuntu" ] || [ "$sys_name" = "kali" ]; then
        local run="apt update"
    elif [ "$sys_name" = "arch" ]; then
        local run="pacman -Sy"
    elif [ "$sys_name" = "centos" ] || [ "$sys_name" = "redhat" ]; then
        local run="yum -y update"
    elif [ "$sys_name" = "termux" ]; then
        local run="apt update"
    elif [ "$sys_name" = "darwin" ]; then
        local run="brew update"
    fi
    eval "$run"
}

check_curl() {
    if ! command -v curl; then
        echo -e "${COLOR_YELLOW}[*] Curl is not installed, start downloading and installing...${COLOR_DEFAULT}"
        if [ "$sys_name" = "alpine" ]; then
            apk add curl
        elif [ "$sys_name" = "debian" ] || [ "$sys_name" = "ubuntu" ] || [ "$sys_name" = "kali" ]; then
            apt install -y curl
        elif [ "$sys_name" = "arch" ]; then
            pacman -Sy curl
        elif [ "$sys_name" = "centos" ] || [ "$sys_name" = "redhat" ]; then
            yum install -y curl
        elif [ "$sys_name" = "termux" ]; then
            apt install -y curl
        elif [ "$sys_name" = "darwin" ]; then
            brew install -y curl
        fi
    fi
}
check_wget() {
    if ! command -v wget; then
        echo -e "${COLOR_YELLOW}[*] Wget is not installed, start downloading and installing...${COLOR_DEFAULT}"
        if [ "$sys_name" = "alpine" ]; then
            apk add wget
        elif [ "$sys_name" = "debian" ] || [ "$sys_name" = "ubuntu" ] || [ "$sys_name" = "kali" ]; then
            apt install -y wget
        elif [ "$sys_name" = "arch" ]; then
            pacman -Sy wget
        elif [ "$sys_name" = "centos" ] || [ "$sys_name" = "redhat" ]; then
            yum install -y wget
        elif [ "$sys_name" = "termux" ]; then
            apt install -y wget
        elif [ "$sys_name" = "darwin" ]; then
            brew install -y wget
        fi
    fi
}
check_git() {
    if ! command -v git; then
        echo -e "${COLOR_YELLOW}[*] Git is not installed, start downloading and installing...${COLOR_DEFAULT}"
        if [ "$sys_name" = "alpine" ]; then
            apk add git
        elif [ "$sys_name" = "debian" ] || [ "$sys_name" = "ubuntu" ] || [ "$sys_name" = "kali" ]; then
            apt install -y git
        elif [ "$sys_name" = "arch" ]; then
            pacman -Sy git
        elif [ "$sys_name" = "centos" ] || [ "$sys_name" = "redhat" ]; then
            yum install -y git
        elif [ "$sys_name" = "termux" ]; then
            apt install -y git
        elif [ "$sys_name" = "darwin" ]; then
            brew install -y git
        fi
    fi
}
check_python3_pip3() {
    if ! command -v python3 || ! command -v pip3; then
        echo -e "${COLOR_YELLOW}[*] Python3 or pip3 is not installed, start downloading and installing...${COLOR_DEFAULT}"
        if [ "$sys_name" = "alpine" ]; then
            apk add python3 py3-pip
        elif [ "$sys_name" = "debian" ] || [ "$sys_name" = "ubuntu" ] || [ "$sys_name" = "kali" ]; then
            apt install -y python3 python3-pip
        elif [ "$sys_name" = "arch" ]; then
            pacman -Sy python3 python-pip
        elif [ "$sys_name" = "centos" ] || [ "$sys_name" = "redhat" ]; then
            yum install -y python3
        elif [ "$sys_name" = "termux" ]; then
            apt install -y python python-pip
        elif [ "$sys_name" = "darwin" ]; then
            brew install -y python
        fi
    fi
}
check_go() {
    if ! command -v go; then
        echo -e "${COLOR_YELLOW}[*] Go is not installed, start downloading and installing...${COLOR_DEFAULT}"
        if [ "$sys_name" = "alpine" ]; then
            apk add go
        elif [ "$sys_name" = "debian" ] || [ "$sys_name" = "ubuntu" ] || [ "$sys_name" = "kali" ]; then
            apt install -y golang
        elif [ "$sys_name" = "arch" ]; then
            pacman -Sy go
        elif [ "$sys_name" = "centos" ] || [ "$sys_name" = "redhat" ]; then
            yum install -y golang
        elif [ "$sys_name" = "termux" ]; then
            apt install -y golang
        elif [ "$sys_name" = "darwin" ]; then
            brew install -y go
        fi
    fi
}
check_ruby_gem() {
    if ! command -v ruby || ! command -v gem; then
        echo -e "${COLOR_YELLOW}[*] Ruby or Gem is not installed, start downloading and installing...${COLOR_DEFAULT}"
        if [ "$sys_name" = "alpine" ]; then
            apk add ruby ruby-irb ruby-dev build-base
        elif [ "$sys_name" = "debian" ] || [ "$sys_name" = "ubuntu" ] || [ "$sys_name" = "kali" ]; then
            apt install -y ruby-full
        elif [ "$sys_name" = "arch" ]; then
            pacman -Sy ruby
        elif [ "$sys_name" = "centos" ] || [ "$sys_name" = "redhat" ]; then
            yum install -y ruby ruby-devel
        elif [ "$sys_name" = "termux" ]; then
            pkg install -y ruby
        elif [ "$sys_name" = "darwin" ]; then
            brew install ruby
        fi
    fi
}
check_code() {
    echo -e "${COLOR_GREEN}[+] Check the software package dependence...Wait.${COLOR_DEFAULT}"
    check_curl
    check_wget
    check_git
    check_python3_pip3
    check_go
    check_ruby_gem
}
update_run
check_code

mkdir -p "$MAIN_DIR" "$BIN" "$CACHE" "$FOXINDEX"
echo "minimal" > "$ST"
echo "#Jiuwei repository" > "$CONFIG"
echo "SOURCE=\"https://gitee.com/CNTangyuan/JiuWei-repository/raw/master\"" >> "$CONFIG"
touch "$HBI" "$PACKAGES"

cd "$BIN"

# 使用wget命令从指定URL下载文件
if ! wget -N --no-clobber "https://gitee.com/CNTangyuan/JiuWei-repository/raw/master/fox"; then
    echo -e "${COLOR_RED}[ERROR] An error occurred while downloading...Exit.${COLOR_DEFAULT}"
    exit 1
fi
chmod +x fox

if [ ! -n "$TERMUX_VERSION" ]; then
    echo "export \"PATH=\$PATH:$MAIN_DIR/.bin\"" > /data/data/com.termux/files/usr/etc/profile.d/JiuWei.sh
    chmod +x /data/data/com.termux/files/usr/etc/profile.d/JiuWei.sh
else
    echo "export \"PATH=\$PATH:$MAIN_DIR/.bin\"" > /etc/profile.d/JiuWei.sh
    chmod +x /etc/profile.d/JiuWei.sh
fi
export PATH="$PATH:$MAIN_DIR/.bin"

wget -N --no-clobber https://gitee.com/CNTangyuan/JiuWei/raw/master/Remove_JiuWei.sh
chmod +x Remove_JiuWei.sh

echo -e "${COLOR_GREEN}[INFO] Welcome to use JiuWei ~ Fox want to hug you.\(つ≧▽≦\)つ${COLOR_DEFAULT}"