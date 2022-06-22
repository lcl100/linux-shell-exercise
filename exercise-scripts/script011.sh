#!/bin/bash

####################################
#
# 功能：当执行程序时，让使用者选择 boy 或者 girl，如果使用者输入 B 或者 b，则显示 He is a boy；当使用者输入 G 或者 g，则显示 She is a girl；如果是除了 B/b/G/g 之外的其他字符，则显示 I don't know。
#
# 使用：直接执行，无须任何参数。
#
####################################

##
# 根据读入的数据判断性别并输出对应的提示信息
##
function choose_gender() {
  # 读取输入的性别
  read -p "请选择 boy 或者 girl：" gender
  # 判断输入的是否是 "B" 或者 "b"，如果是则表示是 boy
  if [ "$gender" = "B" -o "$gender" = "b" ]; then
      echo "He is a boy."
  # 判断输入的是否是 "G" 或者 "g"，如果是则表示是 girl
  elif [ "$gender" = "G" -o "$gender" = "g" ]; then
      echo "She is a girl."
  # 如果都不是，则提示不知道
  else
      echo "I don't know."
  fi
}

##
# 主函数
##
function main() {
  # 在主函数中调用
  choose_gender
}

# 调用主函数
main
