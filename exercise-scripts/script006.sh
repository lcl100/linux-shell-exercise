#!/bin/bash

##
# 打印乘法表
# @param $1 第一个参数，表示传入的数字，从 [1, 9] 中任取一个整数表示输出几行的乘法表
##
function print_multiplication_table() {
  # 参数校验，如果参数个数为 0 则给出提示
  if [ $# -eq 0 ]; then
      echo "请输入一个参数！"
      exit
  fi

  # 接收一个参数表示几行乘法表
  local num=$1
  # 双层 for 循环打印乘法表
  for (( i = 1; i <= $num; i++ )); do
      for (( j = 1; j <= $i; j++ )); do
          # 计算 i*j 的结果
          local result=$[$i*$j]
          # -e 表示让制表符生效；-n 表示不换行
          echo -ne "$i*$j=$result\t"
      done
      # 换行
      echo
  done
}

##
# 主函数
##
function main() {
  # 在主函数中调用
  print_multiplication_table "$1"
}

# 调用主函数
main "$1"