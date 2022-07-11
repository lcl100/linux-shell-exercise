#!/bin/bash

# 可以将一个字符串中的每个字符单独换行输出
# printf "hello" | sed 's/\w/&\n/g'

# 计数器变量，统计每行出现数字在 [1-5] 的数字的总个数
count=0
# 行号变量，记录当前行的行号
line_number=0
# 循环读取每一行
while read line; do
    # 行号加一
    line_number=$(($line_number+1))
    # 计算当前行中出现数字在 [1-5] 的数字的个数
    num=$(printf "${line}" | sed 's/\w/&\n/g' | grep -c -E "[1-5]")
    # 打印每行个数
    echo "line${line_number} number: ${num}"
    # 将每行个数添加到总个数中
    count=$(($num+$count))
done < nowcoder.txt
# 打印最终总个数
echo "sum is ${count}"