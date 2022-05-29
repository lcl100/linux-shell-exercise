#!/bin/bash

##
# 显示最大值和最小值
##
function show_max_and_min() {
  # 局部变量，分别记录最大数和最小数
  local max
  local min
  # 循环输入 10 个数
  for (( i = 0; i < 10; i++ )); do
      # 从键盘读入一个数，存储到变量 num 中
      read num
      # 如果 i 等于 0 则初始 max 和 min 为第一个数
      if [ $i -eq 0 ]; then
        # 将 max 和 min 都初始为读入的 num
        min=$num
        max=$num
      # 如果 i 不等于 0，则将当前读入的数与最大值 max 和最小值 min 进行比较
      else
        # 如果当前 num 小于 min，那么就将 num 赋值给 min
        if [ $num -lt $min ]; then
            min=$num
        fi
        # 如果当前 num 大于 max，那么就将 num 赋值给 max
        if [ $num -gt $max ]; then
            max=$num
        fi
      fi
  done

  # 最后打印最大值和最小值
  echo "最大值：$max"
  echo "最小值：$min"
}

##
# 主函数
##
function main() {
  # 在主函数中调用
  show_max_and_min
}

# 调用主函数
main