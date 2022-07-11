#!/bin/bash

# 获取输入的数组长度
read length

# 变量，记录输入的总和
sum=0
# 循环输入
for (( i = 0; i < ${length}; i++ )); do
	# 读取输入的数字
    read num
    # 计算到总和中
    sum=$[ sum + num ]
done
# 计算平均值
avg=$(echo "scale=3;${sum}/${length}" | bc)
echo ${avg}