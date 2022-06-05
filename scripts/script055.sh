#!/bin/bash

####################################
#
# 功能：将 /etc/passwd/ 中的第三个字段数字最大的后 10 个用户信息全部改为大写后保存至 /tmp/maxusers.txt。
#
# 使用：直接调用脚本，不需要任何参数
#
# 作者：lcl100
#
# 日期：2022-06-04
#
####################################


# 将 /etc/passwd/ 中的第三个字段数字最大的后 10 个用户信息全部改为大写后保存至 /tmp/maxusers.txt
cat /etc/passwd | sort -t ":" -k 3 -n | tail -n 10 | tr "[a-z]" "[A-Z]" > /tmp/maxusers.txt