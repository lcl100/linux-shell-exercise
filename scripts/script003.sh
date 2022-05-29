#!/bin/bash

##
# 展示用户名
##
function show_username() {
  # 取出 /etc/passwd 文件的第一列
  local usernames=$(cut -d ":" -f 1 "/etc/passwd")
  # 循环遍历所有用户名，拼接字符串进行显示
  for username in $usernames ; do
      echo "The account is '$username'"
  done
}

##
# 主函数
##
function main() {
  show_username
}

# 调用主函数
main