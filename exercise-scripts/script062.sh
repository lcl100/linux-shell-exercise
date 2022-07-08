#!/bin/bash


####################################
#
# 功能：写一个脚本，输出一个文本文件 `nowcoder.txt` 中第5行的内容。
#
# 使用：直接调用脚本，不需要任何参数
#
# 作者：lcl100
#
# 日期：2022-07-08
#
####################################


i=0
while read line; do
  i=$((${i}+1))
  if [ $i -eq 5 ]; then
      echo "${line}"
      exit
  fi
done < nowcoder.txt