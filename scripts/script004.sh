#!/bin/bash

# 声明变量
# 待判断查看的指定路径名称
DEST_PATH="/root/test/logical"

##
# 检查路径
##
function check_path() {
  # 判断文件是否存在，如果存在则继续下一步
  if [ -e "$DEST_PATH" ]; then
      # 如果文件存在并且是一个普通文件
      if [ -f "$DEST_PATH" ]; then
        # 则先删除这个文件
        rm -rf "$DEST_PATH"
        # 再创建一个同名目录出来
        mkdir -p "$DEST_PATH"
      # 如果文件存在并且是一个目录
      elif [ -d "$DEST_PATH" ]; then
        # 则删除这个目录
        rm -rf "$DEST_PATH"
      fi
  # 如果文件不存在，则使用 touch 命令创建文件
  else
      touch "$DEST_PATH"
  fi
}

##
# 主函数
##
function main() {
  check_path
}

# 调用主函数
main