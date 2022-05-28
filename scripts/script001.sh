#!/bin/bash

# 定义变量
# 目标目录
DEST_DIR="/home"
# 目录名前缀
DIR_PREFIX="a"

##
# 批量创建目录，如 /home/a1、/home/a2、/home/a3 等
##
function create_directory_batch() {
    # 从 1 循环到 100
    local i=1
    # 即 while(i<=100)
    while [ $i -le 100 ]; do
        # 循环体内的操作，即创建目录
        # 目录名，拼接前缀和数字，如 a1、a100 等
        local DIR_NAME="$DIR_PREFIX$i"
        # 根据目录路径和目录名创建目录
        mkdir "$DEST_DIR/$DIR_NAME"
        # 相当于 i++
        i=$[$i+1]
    done
}

##
# 主函数
##
function main() {
  # 调用批量创建目录的函数
  create_directory_batch
}

# 调用主函数
main