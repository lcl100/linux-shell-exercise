# script009
## 题目

写一个脚本，统计 `/etc/` 目录下共有多少文件和目录。





## 分析

本题考查的知识点：

- 自定义函数
- 变量和局部变量
- `find` 命令
- `wc` 命令
- `echo` 命令

思路：

- 通过 `find` 命令找到只当目录下的所有文件，注意使用 `-type f ` 选项表示筛选普通文件，然后通过 `wc -l` 命令统计查询结果的行数，就是文件数目。
- 通过 `find` 命令找到只当目录下的所有目录，注意使用 `-type d` 选项表示筛选目录，然后通过 `wc -l` 命令统计查询结果的行数，就是目录数目。





## 脚本

```shell
#!/bin/bash

####################################
#
# 功能：写一个脚本，统计 /etc/ 目录下共有多少文件和目录。
#
# 使用：直接执行，无须任何参数。
#
####################################

# 声明变量
# 指定目标目录
DEST_DIR="/etc"

##
# 统计指定目录下文件和目录数目
##
function count_file_and_dir() {
  # 声明局部变量，分别记录文件数目和目录数目
  local file_count=0
  local dir_count=0
  # 查找指定目录下所有文件，统计其数目
  file_count=$(find "$DEST_DIR" -type f | wc -l)
  # 查找指定目录下所有目录，统计其数目
  dir_count=$(find "$DEST_DIR" -type d | wc -l)
  # 打印结果
  echo "指定文件夹 $DEST_DIR 下有 $file_count 个文件和 $dir_count 个目录！"
}

##
# 主函数
##
function main() {
  # 在主函数中调用
  count_file_and_dir
}

# 调用主函数
main

```





## 测试

执行 `./script009.sh` 启动脚本：

![image-20220530201302954](image-script009/image-20220530201302954.png)

