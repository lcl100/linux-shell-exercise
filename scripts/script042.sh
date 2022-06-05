#!/bin/bash

####################################
#
# 功能：写一个脚本：
#       1. 显示当前系统日期和时间，而后创建目录 /tmp/lstest
#       2. 切换工作目录至 /tmp/lstest
#       3. 创建目录 a1d，b56e，6test
#       4. 创建空文件 xy，x2y，732
#       5. 列出当前目录下以 a，x 或者 6 开头的文件或目录
#       6. 列出当前目录下以字母开头，后跟一个任意数字，而后跟任意长度字符的文件或目录
#
# 使用：直接执行，不需要任何参数
#
####################################


# 变量，目标目录
DEST_DIR="/tmp/lstest"

# 显示当前系统日期和时间
date "+%Y-%m-%d %H:%M:%S"
# 而后创建目录 /tmp/lstest
if [ ! -d "$DEST_DIR" ]; then
    mkdir -p "$DEST_DIR"
fi

# 切换工作目录至 /tmp/lstest
cd "$DEST_DIR" || exit

# 创建目录 a1d，b56e，6test，注意目录不存在才进行创建，否则不创建
if [ ! -d "./a1d" ]; then
    mkdir a1d
fi
if [ ! -d "./b56e" ]; then
    mkdir b56e
fi
if [ ! -d "./6test" ]; then
    mkdir 6test
fi

# 创建空文件 xy，x2y，732，注意目录不存在才进行创建，否则不创建
if [ ! -f "./xy" ]; then
    touch xy
fi
if [ ! -f "./x2y" ]; then
    touch x2y
fi
if [ ! -f "./732" ]; then
    touch 732
fi

# 列出当前目录下以 a，x 或者 6 开头的文件或目录
echo "列出当前目录下以 a，x 或者 6 开头的文件或目录："
find . -name "[ax6]*"
echo

# 列出当前目录下以字母开头，后跟一个任意数字，而后跟任意长度字符的文件或目录
echo "列出当前目录下以字母开头，后跟一个任意数字，而后跟任意长度字符的文件或目录："
find . -name "[a-zA-Z][0-9]*"