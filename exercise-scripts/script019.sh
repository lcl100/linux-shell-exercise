#!/bin/bash

####################################
#
# 功能：计算 /etc/passwd 文件中的第 10 个用户和第 20 个用户的ID之和
#
# 使用：直接调用，不需要任何参数
#
####################################


# 获取第 10 个用户的用户 ID，即 /etc/passwd 文件的第 10 行第 3 个字段（通过冒号分隔）
user_id1=$(cat /etc/passwd | head -n 10 | tail -n 1 | cut -d ":" -f 3)
# 获取第 20 个用户的用户 ID，即 /etc/passwd 文件的第 20 行第 3 个字段（通过冒号分隔）
user_id2=$(cat /etc/passwd | head -n 20 | tail -n 1 | cut -d ":" -f 3)
# 计算两个用户 ID 之和
result=$(($user_id1+$user_id2))
# 打印相加结果
echo "第 10 个用户和第 20 个用户的ID之和为：$result"