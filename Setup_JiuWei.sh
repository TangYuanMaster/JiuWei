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

MAIN_DIR="/opt/JiuWei"
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

update_run() {
    if [ "$parameters_1" = "--no-update" ] || [ "$parameters_2" = "--no-update" ]; then
        echo -e "${COLOR_YELLOW}[*] Skip update～=_=${COLOR_DEFAULT}"
    else:
        echo -e "${COLOR_YELLOW}[*] Update...${COLOR_DEFAULT}"
        if [ "$sys_name" = "alpine" ]; then
            local run="apk update"
        elif [ "$sys_name" = "debian" ] || [ "$sys_name" = "ubuntu" ] || [ "$sys_name" = "kali" ]; then
            local run="apt update"
        elif [ "$sys_name" = "arch" ]; then
            local run="pacman -Sy"
        elif [ "$sys_name" = "centos" ]; then
            local run="dnf -y update"
        elif [ "$sys_name" = "termux" ]; then
            local run="apt update"
        elif [ "$sys_name" = "darwin" ]; then
            local run="brew update"
        fi
    fi
    if [ "$parameters_1" = "--no-update" ] || [ "$parameters_2" = "--no-update" ]; then
        echo "$run"
    fi
}

check_curl() {
    if ! command -v curl &> /dev/null; then
        echo -e "${COLOR_YELLOW}[*] Curl is not installed, start downloading and installing...${COLOR_DEFAULT}"
        if [ "$sys_name" = "alpine" ]; then
            apk add curl
        elif [ "$sys_name" = "debian" ] || [ "$sys_name" = "ubuntu" ] || [ "$sys_name" = "kali" ]; then
            apt install -y curl
        elif [ "$sys_name" = "arch" ]; then
            pacman -Sy curl
        elif [ "$sys_name" = "certos" ]; then
            dnf install -y curl
        elif [ "$sys_name" = "termux" ]; then
            apt install -y curl
        elif [ "$sys_name" = "darwin" ]; then
            brew install -y curl
        fi
    fi
}
check_wget() {
    if ! command -v wget &> /dev/null; then
        echo -e "${COLOR_YELLOW}[*] Wget is not installed, start downloading and installing...${COLOR_DEFAULT}"
        if [ "$sys_name" = "alpine" ]; then
            apk add wget
        elif [ "$sys_name" = "debian" ] || [ "$sys_name" = "ubuntu" ] || [ "$sys_name" = "kali" ]; then
            apt install -y wget
        elif [ "$sys_name" = "arch" ]; then
            pacman -Sy wget
        elif [ "$sys_name" = "centos" ]; then
            dnf install -y wget
        elif [ "$sys_name" = "termux" ]; then
            apt install -y wget
        elif [ "$sys_name" = "darwin" ]; then
            brew install -y wget
        fi
    fi
}
check_git() {
    if ! command -v git &> /dev/null; then
        echo -e "${COLOR_YELLOW}[*] Git is not installed, start downloading and installing...${COLOR_DEFAULT}"
        if [ "$sys_name" = "alpine" ]; then
            apk add git
        elif [ "$sys_name" = "debian" ] || [ "$sys_name" = "ubuntu" ] || [ "$sys_name" = "kali" ]; then
            apt install -y git
        elif [ "$sys_name" = "arch" ]; then
            pacman -Sy git
        elif [ "$sys_name" = "certos" ]; then
            dnf install -y git
        elif [ "$sys_name" = "termux" ]; then
            apt install -y git
        elif [ "$sys_name" = "darwin" ]; then
            brew install -y git
        fi
    fi
}
check_python3_pip3() {
    if [ ! command -v python3 &> /dev/null ] || [! command -v pip3 &> /dev/null]; then
        echo -e "${COLOR_YELLOW}[*] Python3 or pip3 is not installed, start downloading and installing...${COLOR_DEFAULT}"
        if [ "$sys_name" = "alpine" ]; then
            apk add python3 py3-pip
        elif [ "$sys_name" = "debian" ] || [ "$sys_name" = "ubuntu" ] || [ "$sys_name" = "kali" ]; then
            apt install -y python3 python3-pip
        elif [ "$sys_name" = "arch" ]; then
            pacman -Sy python3 python-pip
        elif [ "$sys_name" = "certos" ]; then
            dnf install -y python3
        elif [ "$sys_name" = "termux" ]; then
            apt install -y python3 python3-pip
        elif [ "$sys_name" = "darwin" ]; then
            brew install -y python
        fi
    fi
}
check_go() {
    if ! command -v go &> /dev/null; then
        echo -e "${COLOR_YELLOW}[*] Go is not installed, start downloading and installing...${COLOR_DEFAULT}"
        if [ "$sys_name" = "alpine" ]; then
            apk add go
        elif [ "$sys_name" = "debian" ] || [ "$sys_name" = "ubuntu" ] || [ "$sys_name" = "kali" ]; then
            apt install -y golang
        elif [ "$sys_name" = "arch" ]; then
            pacman -Sy go
        elif [ "$sys_name" = "certos" ]; then
            dnf install -y golang
        elif [ "$sys_name" = "termux" ]; then
            apt install -y go
        elif [ "$sys_name" = "darwin" ]; then
            brew install -y go
        fi
    fi
}
check_ruby_gem() {
    if ! command -v ruby &> /dev/null || ! command -v gem &> /dev/null; then
        echo -e "${COLOR_YELLOW}[*] Ruby or Gem is not installed, start downloading and installing...${COLOR_DEFAULT}"
        if [ "$sys_name" = "alpine" ]; then
            apk add ruby ruby-irb ruby-dev build-base
        elif [ "$sys_name" = "debian" ] || [ "$sys_name" = "ubuntu" ] || [ "$sys_name" = "kali" ]; then
            apt install -y ruby-full
        elif [ "$sys_name" = "arch" ]; then
            pacman -Sy ruby
        elif [ "$sys_name" = "centos" ]; then
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
echo "nano" > "$ST"
echo "#Jiuwei repository" > "$CONFIG"
echo "SOURCE=\"https://gitee.com/CNTangyuan/JiuWei-repository/raw/master\"" >> "$CONFIG"
touch "$HBI" "$PACKAGES"

cd "$BIN"

# 使用wget命令从指定URL下载文件
if ! wget "https://gitee.com/CNTangyuan/JiuWei-repository/raw/master/fox"; then
    echo -e "${COLOR_RED}[ERROR] An error occurred while downloading...Exit.${COLOR_DEFAULT}"
    exit 1
fi
chmod +x fox
echo 'export $PATH:/opt/JiuWei/.bin' > /etc/profile.d/JiuWei.sh

wget https://gitee.com/CNTangyuan/JiuWei/raw/master/Remove_JiuWei
chmod +x Remove_JiuWei

echo -e "${COLOR_GREEN}[INFO] Welcome to use JiuWei ~ Fox want to hug you.(つ≧▽≦)つ${COLOR_DEFAULT}"