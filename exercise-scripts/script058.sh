#!/bin/bash

####################################
#
# 功能：写一个脚本，传递一个用户名参数给脚本：如果用户的 id 号大于等于 500，且其默认 shell 为以 sh 结尾的字符串，则显示 “a user can log system.” 类的字符串；否则，则显示无法登录系统。
#
# 使用：直接调用脚本，不需要任何参数
#
# 作者：lcl100
#
# 日期：2022-06-04
#
####################################


# 参数校验，校验参数个数
if [ $# -ne 1 ]; then
    echo "请输入一个参数！"
    exit
fi

# 获取用户输入的用户名
username="$1"
# 应该判断用户是否存在，如果不存在则退出
id $username &> /dev/null
if [ $? -ne 0 ]; then
    echo "该用户不存在！"
    exit
fi

# 在 /etc/passwd 中文件查找该用户的用户 ID，避免正则表达式匹配多行
user_id=$(egrep "^${username}:.*sh$" /etc/passwd | cut -d ":" -f 3)

# 判断用户 ID 大于等于 500
if [ $user_id -ge 500 ]; then
    echo "a user can log system."
else
    echo "can not log."
fi