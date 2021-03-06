# script016 
## 题目

编写 `/roo/bin/argsnum.sh`，接受一个文件路径作为参数，如果参数个数小于 1，则提示用户“至少应该给一个参数”，并立即退出；如果参数个数不小于 1，则显示第一个参数所指向的文件中的空白行数。





## 分析

本题考查的知识点：

- 数字比较
- `if...elif` 和 `if...else` 多分支条件语句
- `grep` 命令

思路：

- 首先校验用户调用脚本是否输入一个参数，其次传入的文件路径必须存在并且是一个普通文件。
- 然后通过 `grep` 命令查找文件中的空白行。这里使用了正则表达式 `"^$"` 去匹配文件中的空白行；而 `-c` 选项可以统计查询结果的行数。
- 最终打印结果。





## 脚本

```shell
#!/bin/bash

####################################
#
# 功能：接受一个文件路径作为参数，如果参数个数小于 1，则提示用户“至少应该给一个参数”，并立即退出；如果参数个数不小于 1，则显示第一个参数所指向的文件中的空白行数。
#
# 使用：传递文件路径作为第一个参数
#
####################################


# 参数校验
# 如果参数个数小于 1 个则给出提示信息并退出
if [ $# -lt 1 ]; then
    echo "请至少应该给一个参数！"
    exit
# 如果参数个数大于等于 1 个则继续进行下一步的操作
elif [ $# -ge 1 ]; then
    # 第一个参数是文件路径
    file_path="$1"
    # 还得判断文件路径是否存在并且是一个文件
    if [ -f "$file_path" ]; then
        # 使用 grep 命令提取空行数
        lines=$(grep "^$" -c "$file_path")
        # 打印结果
        echo "文件 $file_path 中的空白行数为：$lines"
    # 如果文件不存在或者不是文件则给出提示信息
    else
        echo "请输入有效的文件路径！"
    fi
fi
```





## 测试

执行 `./script016.sh filepath` 调用脚本，其中 `filepath` 表示一个有效文件路径。

![image-20220531204851307](image-script016/image-20220531204851307.png)

