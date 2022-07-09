#!/bin/bash


####################################
#
# 功能：写一个脚本，计算一下所有进程占用内存大小的和。
#
# 使用：直接调用脚本，不需要任何参数
#
# 作者：lcl100
#
# 日期：2022-07-09
#
####################################


FILE="nowcoder.txt"

sum=0
while read line; do
    mem=$(echo "${line}" | awk '{print $6}')
    sum=$(( sum + mem ))
done < "${FILE}"

echo "${sum}"