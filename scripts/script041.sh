#!/bin/bash

####################################
#
# 功能：写一个脚本：
#       1. 创建目录 /tmp/scripts
#       2. 切换工作目录至此目录中
#       3. 复制 /etc/pam.d 目录至当前目录，并重命名为 test
#       4. 将当前目录的 test 及其里面的文件和子目录的属主改为 redhat
#       5. 将 test 及其子目录中的文件的其它用户的权限改为没有任何权限
#
# 使用：直接执行，不需要任何参数
#
####################################


# 变量，目标目录
DEST_DIR="/tmp/scripts"

# 判断目录是否存在，如果不存在则进行创建
if [ ! -d "$DEST_DIR" ]; then
    mkdir -p "$DEST_DIR"
fi

# 切换到该目录下
cd "$DEST_DIR" || exit

# 复制 /etc/pam.d 目录至当前目录，并重命名为 test
cp -R "/etc/pam.d" test

# 将当前目录的 test 及其里面的文件和子目录的属主改为 redhat
# 判断用户 redhat 是否存在，如果不存在则创建该用户，如果存在则修改权限
id "redhat" &> /dev/null
if [ $? -ne 0 ]; then
    useradd "redhat"
fi
chown -R redhat "./test"

# 将 test 及其子目录中的文件的其它用户的权限改为没有任何权限
chmod -R o-w,o-r,o-x "./test"