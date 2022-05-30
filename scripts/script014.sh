#!/bin/bash

####################################
#
# 功能：判断参数文件是否为 .sh 后缀的普通文件，如果是，则添加所有人可执行权限，否则提示非脚本文件。
#
# 使用：传入一个脚本文件作为第一个参数
#
####################################

##
# 为脚本文件添加执行权限
# @param $1 脚本文件路径
##
function give_execute_permission() {
  # 参数校验
  if [ $# -ne 1 ]; then
      echo "请输入一个参数！"
      exit
  fi
  # 第一个参数就是脚本文件
  local script_file
  script_file=$1
  # 提取输入参数文件的后缀
  local suffix
  suffix="${script_file##*.}"
  # 判断后缀是否是 "sh"
  if [ "$suffix" = "sh" ]; then
      # 如果是脚本文件则直接给所有用户添加可执行权限
      chmod +x "$script_file"
  else
      # 如果不是脚本文件则给出提示信息
      echo "文件 $script_file 不是脚本文件！"
  fi
}

##
# 主函数
##
function main() {
  # 在主函数中调用
  give_execute_permission "$1"
}

# 调用主函数
main "$1"
