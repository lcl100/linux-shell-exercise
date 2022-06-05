#!/bin/bash

####################################
#
# 功能：传递两个整数给脚本，让脚本分别计算并显示这两个整数的和、差、积、商。
#
# 使用：直接执行，不需要任何参数
#
####################################


# 参数判断
if [ $# -eq 0 ]; then
    echo "请输入两个参数！"
    exit
elif [ $# -eq 1 ]; then
    echo "请再输入一个参数！"
    exit
elif [ $# -gt 2 ]; then
    echo "只需要两个参数就够了！"
    exit
fi

# 用两个变量接收参数
num1="$1"
num2="$2"

# 计算显示这两个整数的和、差、积、商
sum=$(($num1+$num2))
diff=$(($num1-$num2))
mul=$(($num1*$num2))
div=$(($num1/$num2))
echo "两个整数 $num1 和 $num2 的和为：$sum"
echo "两个整数 $num1 和 $num2 的差为：$diff"
echo "两个整数 $num1 和 $num2 的积为：$mul"
echo "两个整数 $num1 和 $num2 的商为：$div"