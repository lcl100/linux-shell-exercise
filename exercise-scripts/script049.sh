#!/bin/bash

####################################
#
# 功能：输入10个数，同时显示和、最大值、最小值和平均数。
#
# 使用：直接调用脚本，然后输入 10 个数
#
####################################


# 变量，分别用来记录总和、最大值、最小值、平均值
sum=0
max=0
min=0
avg=0

# 循环 10 次从键盘输入数据
for (( i = 1; i <= 10; i++ )); do
    # 从键盘输入获取数据
    read -p "请输入第 $i 个数：" num
    # 计入总和
    sum=$(($num+$sum))
    # 比较判断最大值和最小值
    if [ $i -eq 1 ]; then
        max=$num
        min=$num
    else
        # 比较最大值
        if [ $num -gt $max ]; then
            max=$num
        fi
        # 比较最小值
        if [ $num -lt $min ]; then
            min=$num
        fi
    fi
done

# 计算平均值
avg=$(($sum/10))

# 打印结果
echo "总和：$sum"
echo "最大值：$max"
echo "最小值：$min"
echo "平均值：$avg"