#!/bin/bash

####################################
#
# 功能：统计某目录下包含的文件数、子文件夹数、链接文件数、隐藏文件数（并显示隐藏的文件名）及可执行文件数。
#
# 使用：传入指定目录路径作为第一个参数
#
####################################


# 参数校验，校验参数个数
if [ $# -ne 1 ]; then
    echo "请输入一个参数！"
    exit
fi

# 参数校验，校验目录路径是否真实存在
dir_path="$1"
if [ ! -d "$dir_path" ]; then
    echo "请输入有效目录路径！"
    exit
fi

# 统计各类文件的数目
# 普通文件的数目
file_count=$(ls -l "$dir_path" | egrep "^-" | wc -l)
# 文件夹的数目
dir_count=$(ls -l "$dir_path" | egrep "^d" | wc -l)
# 链接文件的数目
link_count=$(ls -l "$dir_path" | egrep "^l" | wc -l)
# 隐藏文件的数目
hide_count=$(ls -al "$dir_path" | egrep "^-" | awk '{print $9}' | egrep "^\." | wc -l)
# 可执行文件的数目
exec_count=$(ls -l "$dir_path" | egrep "^-" | egrep "(rwx|r-x)" | wc -l)

# 打印结果
echo "目录 $dir_path 下的普通文件数目为：$file_count"
echo "目录 $dir_path 下的文件夹数目为：$dir_count"
echo "目录 $dir_path 下的链接文件数目为：$link_count"
echo "目录 $dir_path 下的隐藏文件数目为：$hide_count"
echo "目录 $dir_path 下的可执行文件数目为：$exec_count"