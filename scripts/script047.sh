#!/bin/bash

####################################
#
# 功能：统计英语一句话中字母数不大于 6 的单词。
#
# 使用：不需要任何参数，直接调用即可
#
####################################

# 变量，待统计的句子
words="The best preparation for tomorrow is doing your best today."

# 循环句子中的每个单词，以空格进行分隔
for word in $words ; do
    # 删除单词中的标点符号
    word=$(echo -n "$word"  | tr -d "[:punct:]")
    # 计算单词的字母个数
    len=$(echo -n "$word" | wc -c)
    # 比较单词的字母个数是否不大于 6
    if [ $len -le 6 ]; then
        echo "$word"
    fi
done