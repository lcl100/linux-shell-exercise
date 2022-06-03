#!/bin/bash

####################################
#
# 功能：让所有用户的 PATH 环境变量的值多出一个路径，例如: /usr/local/apache/bin
#
# 使用：使用 source 命令执行该脚本才会生效，否则修改的环境变量是子 shell 的
#
####################################


# 变量，待添加到环境变量的路径
DEST_PATH="/usr/local/apache/bin"
# 将目标变量与原环境变量进行拼接修改环境变量，中间用分号进行分隔开，然后使用 export 命令提升到全局变量
export PATH="$PATH:$DEST_PATH"
# 只是临时修改了环境变量，如果要永久生效，需要将 export 这句写入到 /etc/profile 文件中