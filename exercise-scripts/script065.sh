#!/bin/bash


####################################
#
# 功能：写一个脚本，统计一个文本文件 `nowcoder.txt` 中字母数小于 `8` 的单词。
#
# 使用：直接调用脚本，不需要任何参数
#
# 作者：lcl100
#
# 日期：2022-07-09
#
####################################


FILE="nowcoder.txt"

words=$(cat "${FILE}" | tr -s ' ' '\n')
for word in ${words} ; do
    if [ ${#word} -lt 8 ]; then
        echo "${word}"
    fi
done