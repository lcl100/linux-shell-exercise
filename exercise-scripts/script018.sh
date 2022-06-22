#!/bin/bash

####################################
#
# 功能：检查磁盘分区空间和 inode 使用率，如果超过 80%，则发广播警告空间将满。
#
# 使用：直接调用，不需要任何参数
#
####################################


# 获取磁盘分区空间的使用率
disk_usage=$(df | egrep -o "[0-9]{1,3}%" | tr -d "%" | sort -nr | head -n 1)
# 如果磁盘空间的使用率大于等于 80% 则给出提示
if [ $disk_usage -ge 80 ]; then
    wall "警告！当前磁盘空间的使用率已经超过 80%！"
fi

# 获取 inode 使用率
inode_usage=$(df -i | egrep -o "[0-9]{1,3}%" | tr -d "%" | sort -nr | head -n 1)
# 如果 inode 的使用率大于等于 80% 则给出提示
if [ $inode_usage -ge 80 ]; then
    wall "警告！当前 inode 的使用率已经超过 80%！"
fi