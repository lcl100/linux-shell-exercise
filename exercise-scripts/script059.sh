#!/bin/bash


####################################
#
# 功能：写一个脚本，输出一个文本文件 `nowcoder.txt` 中的行数。
#
# 使用：直接调用脚本，不需要任何参数
#
# 作者：lcl100
#
# 日期：2022-07-08
#
####################################


count=0

while read line; do
  count=$((${count}+1))
done < nowcoder.txt

echo "${count}"