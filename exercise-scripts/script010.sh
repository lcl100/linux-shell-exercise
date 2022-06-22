#!/bin/bash

####################################
#
# 功能：依次向 /etc/passwd 文件中的每个用户问好，并且输出对方的 ID。
#
# 使用：直接执行，无须任何参数。
#
####################################

##
# 依次向 /etc/passwd 文件中的每个用户问好，并且输出对方的 ID
##
function say_hello() {
  # 提取 /etc/passwd 文件中的每个用户
  local users
  users=$(cut -d ":" -f 1,3 "/etc/passwd")
  # 循环遍历所有的用户，向它们问好
  for user in $users ; do
      # 提取用户名
      local username
      username=$(echo "$user" | cut -d ":" -f 1)
      # 提取用户id
      local userid
      userid=$(echo "$user" | cut -d ":" -f 2)
      echo "hello $username is $userid"
  done
}

##
# 主函数
##
function main() {
  # 在主函数中调用
  say_hello
}

# 调用主函数
main
