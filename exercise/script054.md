# script054 
## 题目

对于按单词出现频率降序排序。





## 分析

本题考查的知识点：

- `echo` 命令
- `tr` 命令
- `sort` 命令
- `uniq` 命令
- `sort` 命令

思路：

- 先将英语句子由行拆成列，即用换行符替换掉原来分隔用的空格字符，使用 `tr` 命令。
- 为了避免统计单词失误，所以要删除掉单词中的标点符号，使用 `tr -d "[:punct:]"`。
- 接着对单词进行排序，让重复单词相邻排列。
- 再使用 `uniq -c` 命令统计每个单词的出现次数。
- 最后使用 `sort -nr` 命令对出现次数按数字倒序排列。

![image-20220605141401542](image-script054/image-20220605141401542.png)





## 脚本

```shell
#!/bin/bash

####################################
#
# 功能：对于按单词出现频率降序排序。
#
# 使用：直接调用脚本，不需要任何参数
#
# 作者：lcl100
#
# 日期：2022-06-04
#
####################################


# 变量，记录句子
words="No. The Bible says Jesus had compassion2 on them for He saw them as sheep without a shepherd. They were like lost sheep, lost in their sin. How the Lord Jesus loved them! He knew they were helpless and needed a shepherd. And the Good Shepherd knew He had come to help them. But not just the people way back then. For the Lord Jesus knows all about you, and loves you too, and wants to help you."

# 先将空格换成换行符，再去除掉标点符号，再排序，再统计每个单词的出现次数，再降序排序
echo "$words" | tr -s " " "\n" | tr -d "[:punct:]" | sort | uniq -c | sort -nr
```





## 测试

执行 `./script054.sh` 调用脚本。

![image-20220605140350540](image-script054/image-20220605140350540.png)

