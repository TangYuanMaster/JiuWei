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

HBI="$MAIN_DIR/$HBI_FILE"
PACKAGES="$MAIN_DIR/$PACKAGES_FILE"
CONFIG="$MAIN_DIR/$CONFIG_FILE"
CACHE="$MAIN_DIR/$CACHE_FILE"
FOXINDEX="$MAIN_DIR/$FOXINDEX_FILE"
BIN="$MAIN_DIR/$BIN_FILE"

main() {
if [ ! -d "$MAIN_DIR" ]; then
    rm -rf "$MAIN_DIR"
else
    echo -e "${COLOR_YELLOW}[WARN] You haven't installed JiuWei, do you need to install?[Y/n]${COLOR_DEFAULT}"
    read -r answer
    if [[ $answer =~ ^[Nn]$ ]]; then
        exit 1
    else
        wget https://gitee.com/CNTangyuan/JiuWei/raw/master/Setup_JiuWei
        chmod +x Setup_JiuWei
        ./Setup_JiuWei
    fi
fi
}

echo -e "${COLOR_YELLOW}[WARN] Are you sure you want to delete JiuWei? The fox will be sad when you delete JiuWei?[y/N]${COLOR_DEFAULT}"
read -r answer
if [[ $answer =~ ^[Yy]$ ]]; then
    main
else
    echo -e "${COLOR_YELLOW}[WARN] Sure enough, you still love me~ Love you too!\(♡\(˃͈ દ ˂͈ ༶ \)${COLOR_DEFAULT}"
fi