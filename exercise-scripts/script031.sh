#!/bin/bash

####################################
#
# 功能：用户 root 登录时，将命令指示符变成红色，并自动启用一些设置的别名
#
# 使用：直接执行，不需要任何参数。需要修改环境变量 PS1，需要使用 source 命令执行才会生效
#
####################################


# 定义一个变量，用来存储 /root/.bashrc 文件的路径
CONFIG_FILE="/root/.bashrc"
# 修改命令提示符的颜色
export PS1='\[\e[1;31m\][\u@\h \W]\$\[\e[0m\] '
# 将下面这些别名添加到 /root/.bashrc 文件中。实际上从一个专门存有别名的文件中读取所有别名再追加到 /root/.bashrc 文件中比较合适
echo "alias rm='rm -i'" >> "$CONFIG_FILE"
echo "alias cdnet='cd /etc/sysconfig/network-scripts/'" >> "$CONFIG_FILE"
echo "alias editnet='vim /etc/sysconfig/network-scripts/ifcfg-eth0'" >> "$CONFIG_FILE"

# 执行 source 命令让配置文件生效
source /root/.bashrc