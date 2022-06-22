#!/bin/bash

####################################
#
# 功能：写一个脚本，统计 /etc/ 目录下共有多少文件和目录。
#
# 使用：直接执行，无须任何参数。
#
####################################

# 声明变量
# 指定目标目录
DEST_DIR="/etc"

##
# 统计指定目录下文件和目录数目
##
function count_file_and_dir() {
  # 声明局部变量，分别记录文件数目和目录数目
  local file_count=0
  local dir_count=0
  # 查找指定目录下所有文件，统计其数目
  file_count=$(find "$DEST_DIR" -type f | wc -l)
  # 查找指定目录下所有目录，统计其数目
  dir_count=$(find "$DEST_DIR" -type d | wc -l)
  # 打印结果
  echo "指定文件夹 $DEST_DIR 下有 $file_count 个文件和 $dir_count 个目录！"
}

##
# 主函数
##
function main() {
  # 在主函数中调用
  count_file_and_dir
}

# 调用主函数
main
