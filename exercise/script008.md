# script008
## 题目

将个人用户下任意目录下所有文件的扩展名改为 `.bak`。





## 分析

本题考查的知识点：

- 自定义函数
- 变量和局部变量
- `find` 命令
- `grep` 命令
- `for...in` 循环语句
- `${}` 
- `mv` 命令

思路：

- 找到指定目录下的所有普通文件，注意排除目录和隐藏文件。
- 循环遍历所有普通文件路径，通过 `${}` 提取文件路径但去处后缀。如 `/home/zhangsan/hello.txt` 得到 `/home/zhangsan/hello`。
- 然后对每个文件进行重命名。





## 脚本

```shell
#!/bin/bash

####################################
#
# 功能：将个人用户下任意目录下所有文件的扩展名改为 .bak。
#
# 使用：直接执行，无须任何参数。
#
####################################

# 声明变量
# 起始目标目录，即用户的家目录
DEST_DIR="/home/zhangsan"
# 改变后的文件后缀名
DEST_SUFFIX=".bak"

##
# 修改指定目录下所有文件的扩展名
##
function change_extension_name() {
  # 获取指定目录下的所有普通文件
  local files=$(find "$DEST_DIR" -type f | grep -v "/\\.")
  # 循环遍历所有找到的文件路径
  for file in $files ; do
      # 获取文件除了后缀名前面的内容，如 /home/zhangsan/hello.txt 得到 /home/zhangsan/hello
      local prefix="${file%.*}"
      # 对文件进行重命名
      mv "$file" "$prefix$DEST_SUFFIX"
  done
}

##
# 主函数
##
function main() {
  # 在主函数中调用
  change_extension_name
}

# 调用主函数
main
```





## 测试

执行 `./script008.sh` 启动脚本：

![image-20220530200404659](image-script008/image-20220530200404659.png)

