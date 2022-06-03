#!/bin/bash

####################################
#
# 功能：任意用户登录系统时，显示红色字体的警示提醒信息 Hi, dangerous!。
#
# 使用：直接执行，不需要任何参数
#
####################################

WELCOME_PATH="/etc/motd"

if [ -f "$WELCOME_PATH" ]; then
    echo -e "\E[1;31mHi dangerous!\E[0m" > /etc/motd
fi
