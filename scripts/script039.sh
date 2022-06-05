#!/bin/bash

####################################
#
# 功能：循环读取文件 /etc/passwd 文件的第 2、4、6、10、13、15 行，并显示其内容，然后把这些行保存至文件 /tmp/mypasswd 文件中。
#
# 使用：直接执行，不需要任何参数
#
####################################


# 变量，待读取的目录
DEST_FILE="/etc/passwd"
# 变量，保存指定行的目录
SAVED_FILE="/tmp/mypasswd"

# 判断 SAVED_FILE 是否存在，如果不存在则创建，如果存在则清空内容
if [ -f "$SAVED_FILE" ]; then
    echo "" > "$SAVED_FILE"
else
    touch "$SAVED_FILE"
fi

# 循环读取指定行
for num in 2 4 6 10 13 15 ; do
    # 读取指定行的内容
    line=$(head -n $num "$DEST_FILE" | tail -n 1)
    # 输出指定行内容
    echo "$line"
    # 将指定行内容追加到指定文件中保存
    echo "$line" >> "$SAVED_FILE"
done