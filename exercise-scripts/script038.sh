#!/bin/bash

####################################
#
# 功能：统计一共有多少个普通用户。
#
# 使用：直接执行，不需要任何参数
#
####################################


cat /etc/passwd | awk -F: '$3>=500' | cut -d ":" -f 1