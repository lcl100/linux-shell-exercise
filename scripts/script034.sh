#!/bin/bash

####################################
#
# 功能：取出网卡 IP 地址。
#
# 使用：直接执行，不需要任何参数
#
####################################


# 获取所有的网卡名字
name=$(ifconfig | grep -E "^[a-zA-Z0-9]+:" | awk '{print $1}' | tr -d ":")
# 获取所有网卡对应的 IP 地址
ipv4_address=$(ifconfig | grep "inet\b" | awk '{print $2}')

# 为了让网卡名字和 IP 地址并列显示，做了如下操作
# 创建一个用来存储所有网卡名字的临时文件，然后将所有的网卡名字写入临时文件
name_temp_file=$(mktemp -t name.XXXXXX)
echo "$name" > "$name_temp_file"
# 创建一个用来存储所有 IP 地址的临时文件，然后将所有的 IP 地址写入临时文件
ipv4_temp_file=$(mktemp -t ipv4.XXXXXX)
echo "$ipv4_address" > "$ipv4_temp_file"
# 使用 paste 命令以列的方式合并两个文件
paste "$name_temp_file" "$ipv4_temp_file"