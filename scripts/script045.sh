#!/bin/bash

####################################
#
# 功能：实现交换两个文件的文件名。
#
# 使用：直接执行，不需要任何参数
#
####################################


# 参数校验，校验参数个数
if [ $# -ne 2 ]; then
    echo "请输入两个有效的文件路径！"
    exit
fi

# 获取两个参数作为文件路径
file_path1="$1"
file_path2="$2"

# 参数校验，校验文件路径是否存在
if [ ! -e "$file_path1" ]; then
    echo "$file_path1 所表示的文件路径不存在！"
    exit
fi
if [ ! -e "$file_path2" ]; then
    echo "$file_path2 所表示的文件路径不存在！"
    exit
fi

# 交换两个文件的文件名
# 声明一个变量，临时保存另外一个文件的文件名
temp_file_path="${file_path1}_tmp"
# 将第一个文件的名字重命名为临时文件名
mv "$file_path1" "$temp_file_path"
# 将第二个文件的名字改为第一个文件的名字
mv "$file_path2" "$file_path1"
# 将临时文件名改回第二个文件的名字
mv "$temp_file_path" "$file_path2"