#!/bin/bash

####################################
#
# 功能：写一个脚本，显示当前系统上所有默认 shell 为 bash 的用户的用户名、UID 以及此类所有用户的 UID 之和。
#
# 使用：直接调用脚本，不需要任何参数
#
# 作者：lcl100
#
# 日期：2022-06-04
#
####################################


# 查找所有默认 shell 为 bash 的用户
bash_users=$(cat /etc/passwd | egrep "bash$")
# 循环遍历所有用户，输出它们的用户名和用户 ID，及计算所有用户的用户 ID 之和
uid_sum=0
for user in $bash_users ; do
    # 获取用户名
    user_name=$(echo "$user" | cut -d ":" -f 1)
    # 获取用户 ID
    user_id=$(echo "$user" | cut -d ":" -f 3)
    # 把用户 ID 计入总和
    uid_sum=$(($uid_sum+$user_id))
    # 打印用户名和用户 ID
    echo "$user_name:$user_id"
done
echo "所有用户的 UID 之和为：$uid_sum"