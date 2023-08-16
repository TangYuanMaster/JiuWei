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
CONFIG_FILE="config.list" #配置文件（文本文件）
FOXINDEX_FILE=".foxindex" #放置FOXINDEX解压后产生的文件（文件夹）
CACHE_FILE=".cache" #放置从源中下载的安装包（文件夹）
BIN_FILE=".bin" #快捷命令存放（文件夹）
ST_FILE=".status" #JiuWei状态检测（文本文件）

HBI="$MAIN_DIR/$HBI_FILE"
PACKAGES="$MAIN_DIR/$PACKAGES_FILE"
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

check_rust_cargo() {
    if ! command -v rustc &> /dev/null || ! command -v cargo &> /dev/null; then
        echo -e "${COLOR_YELLOW}[*] Rust or Cargo is not installed, start downloading and installing...${COLOR_DEFAULT}"
        if [ "$sys_name" = "alpine" ]; then
            apk add rust cargo
        elif [ "$sys_name" = "debian" ] || [ "$sys_name" = "ubuntu" ] || [ "$sys_name" = "kali" ]; then
            curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
            source $HOME/.cargo/env
        elif [ "$sys_name" = "arch" ]; then
            pacman -Sy rust
        elif [ "$sys_name" = "centos" ]; then
            curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
            source $HOME/.cargo/env
        elif [ "$sys_name" = "termux" ]; then
            pkg install -y rust
        elif [ "$sys_name" = "darwin" ]; then
            curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
            source $HOME/.cargo/env
        fi
    fi
}
check_node_npm() {
    if ! command -v node &> /dev/null || ! command -v npm &> /dev/null; then
        echo -e "${COLOR_YELLOW}[*] Node.js or npm is not installed, start downloading and installing...${COLOR_DEFAULT}"
        if [ "$sys_name" = "alpine" ]; then
            apk add nodejs npm
        elif [ "$sys_name" = "debian" ] || [ "$sys_name" = "ubuntu" ] || [ "$sys_name" = "kali" ]; then
            apt install -y nodejs npm
        elif [ "$sys_name" = "arch" ]; then
            pacman -Sy nodejs npm
        elif [ "$sys_name" = "centos" ]; then
            curl -sL https://rpm.nodesource.com/setup_lts.x | bash -
            yum install -y nodejs
        elif [ "$sys_name" = "termux" ]; then
            pkg install -y nodejs
        elif [ "$sys_name" = "darwin" ]; then
            brew install -y node
        fi
    fi
}
check_java() {
    if ! command -v java &> /dev/null || ! command -v javac &> /dev/null; then
        echo -e "${COLOR_YELLOW}[*] Java is not installed, start downloading and installing...${COLOR_DEFAULT}"
        if [ "$sys_name" = "alpine" ]; then
            apk add openjdk8
        elif [ "$sys_name" = "debian" ] || [ "$sys_name" = "ubuntu" ] || [ "$sys_name" = "kali" ]; then
            apt install -y openjdk-11-jdk
        elif [ "$sys_name" = "arch" ]; then
            pacman -Sy jdk-openjdk
        elif [ "$sys_name" = "centos" ]; then
            yum install -y java-11-openjdk-devel
        elif [ "$sys_name" = "termux" ]; then
            pkg install -y openjdk-17
        elif [ "$sys_name" = "darwin" ]; then
            brew install -y openjdk@11
        fi
    fi
}
check_python2_pip2() {
    if ! command -v python2 &> /dev/null || ! command -v pip2 &> /dev/null; then
        echo -e "${COLOR_YELLOW}[*] Python2 or pip2 is not installed, start downloading and installing...${COLOR_DEFAULT}"
        if [ "$sys_name" = "alpine" ]; then
            #需要旧的AlpineLinux源
            apk add python2 py2-pip
        elif [ "$sys_name" = "debian" ] || [ "$sys_name" = "ubuntu" ] || [ "$sys_name" = "kali" ]; then
            apt install -y python2 python-pip
        elif [ "$sys_name" = "arch" ]; then
            pacman -Sy python2 python2-pip
        elif [ "$sys_name" = "centos" ]; then
            yum install -y python2
        elif [ "$sys_name" = "termux" ]; then
            apt install -y python2 python2-pip
        elif [ "$sys_name" = "darwin" ]; then
            brew install -y python@2
        fi
    fi
}
check_code() {
    echo -e "${COLOR_GREEN}[+] Check the software package dependence...Wait.${COLOR_DEFAULT}"
    check_rust_cargo
    check_node_npm
    check_java
    check_python2_pip2
}
update_run
check_code

echo "full" > "$ST"

echo -e "${COLOR_GREEN}[INFO] Thank you for your support of Fox ~ Have a good luck! o(￣▽￣)ｄ${COLOR_DEFAULT}"