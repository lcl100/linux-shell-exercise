#!/bin/bash

####################################
#
# 功能：编写脚本 /root/bin/links.sh，显示正连接本主机的每个远程主机的 IPv4 地址和连接数，并按连接数从大到小排序。
#
# 使用：直接调用脚本，不需要任何参数
#
# 作者：lcl100
#
# 日期：2022-06-04
#
####################################


w -h | tr -s " " | cut -d " " -f 3 | sort | uniq -c | sort -nr