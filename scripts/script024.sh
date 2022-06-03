#!/bin/bash

####################################
#
# 功能：判断用户输入文件路径，显示其文件类型（普通，目录，链接，其它文件类型)。
#
# 使用：输入一个有效的文件路径作为第一个参数
#
####################################


# 校验参数个数
if [ $# -ne 1 ]; then
    echo "请输入一个参数！"
    exit
fi
# 校验参数的有效性
file_path="$1"
if [ ! -e "$file_path" ]; then
    echo "不是有效的文件路径：$file_path"
    exit
fi
# 获取文件的类型字符
file_type_char=$(ls -ld "$file_path" | cut -c 1)
# 根据字符判断文件类型
case "$file_type_char" in
"-")
    echo "$file_path 是普通文件！"
    ;;
"d")
    echo "$file_path 是目录！"
    ;;
"c")
    echo "$file_path 是字符设备文件！"
    ;;
"b")
    echo "$file_path 是块设备文件！"
    ;;
"p")
    echo "$file_path 是管道文件！"
    ;;
"l")
    echo "$file_path 是链接文件！"
    ;;
"s")
    echo "$file_path 是套接字文件！"
    ;;
*)
    echo "$file_path 是其他类型文件！"
    ;;
esac