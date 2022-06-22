#!/bin/bash

####################################
#
# 功能：写一个脚本，显示当前系统上所有，拥有附加组的用户的用户名；并说明共有多少个此类用户。
#
# 使用：直接调用脚本，不需要任何参数
#
# 作者：lcl100
#
# 日期：2022-06-04
#
####################################

# 变量，记录附加组的数目
num=0
# 得到 /etc/passwd 文件中的所有用户
users=$(cat /etc/passwd | cut -d ":" -f 1)
# 遍历所有用户
for user in $users ; do
    # 获取用户组的数目
    user_group_count=$(id -G $user | wc -w)
    # 如果用户组的数组大于 1 则表示拥有附加租
    if [ $user_group_count -gt 1 ]; then
        # 打印拥有附加组的用户名
        echo "$user"
        # 计入总数
        num=$(($num+1))
    fi
done
echo "拥有附加组的用户个数是：$num"