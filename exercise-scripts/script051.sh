#!/bin/bash

####################################
#
# 功能：写一个脚本，分别统计 /etc/rc.d/rc.local、/etc/rc.d/init.d/functions 和 /etc/fstab 文件中以 # 号开头的行数之和，以及总的空白行数。
#
# 使用：直接调用脚本，不需要任何参数
#
# 作者：lcl100
#
# 日期：2022-06-04
#
####################################


# 变量，待统计的目标文件
DEST_FILES="/etc/rc.d/rc.local /etc/rc.d/init.d/functions /etc/fstab"

# 循环所有文件，进行统计
for file in $DEST_FILES ; do
    # 以 #　开头的行数
    count=$(egrep "^#" "$file" | wc -l)
    # 空白行数
    blank_count=$(egrep "^$" "$file" | wc -l)
    # 打印结果
    echo "文件 $file 中以#号开头的有 $count 行，总的空白行有 $blank_count 行"
done